using BeeAware.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;
using System.IO.Compression;
using System.Text.Json;
using WebApplication1.Models;

namespace WebApplication1.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UploadController : ControllerBase
    {

        private readonly IConfiguration _configuration;
        public UploadController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("UploadModule")]
        public ContentResult UploadFile([FromForm] FileModel fileModel)
        {
            try
            {
                
                string path = Path.Combine("Temp/" + fileModel.FileName+".zip");

                using(Stream stream = new FileStream(path, FileMode.Create))
                {
                   
                    fileModel.file.CopyTo(stream);
                } 
                ZipFile.ExtractToDirectory("Temp/" + fileModel.FileName + ".zip", "Temp/" + fileModel.FileName +"/");
                SqlConnection con3 = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());

                SqlCommand cmd3 = new SqlCommand("select * from modules where name = '"+ fileModel.FileName+"'", con3);
                con3.Open();
                SqlDataReader read = cmd3.ExecuteReader();
                var result = new List<Module>(); //上一步read转化成result
                while (read.Read())
                {
                    var a_module = new Module
                    {
                        Name = read.GetString(1),
                    };
                    result.Add(a_module);
                };
                read.Close();
                con3.Close();

                if (result.Count > 0)
                {
                    //update
                }
                else
                {
                    //new
                    string tableUse = "null";

                    if (System.IO.File.Exists("Temp/" + fileModel.FileName + "/" + fileModel.FileName + ".sql"))
                    {
                        tableUse = fileModel.FileName;
                       
                    }
                    SqlConnection con2 = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());
                    SqlCommand cmd2 = new SqlCommand("INSERT INTO modules (Name, Description, tableUse)VALUES('" + fileModel.FileName + "','" + System.IO.File.ReadAllText("Temp/" + fileModel.FileName + "/Description.txt") + "','" + tableUse + "');", con2);
                    con2.Open();//连接数据库
                    int i2 = cmd2.ExecuteNonQuery(); //执行数据库指令
                    con2.Close();
                    if (i2 <= 0)
                    {
                        throw new Exception();
                    }

                    if (System.IO.File.Exists("Temp/" + fileModel.FileName + "/" + fileModel.FileName + ".sql"))
                    {  
                        SqlConnection con = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());
                        SqlCommand cmd = new SqlCommand(System.IO.File.ReadAllText("Temp/" + fileModel.FileName + "/" + fileModel.FileName + ".sql"), con);
                        con.Open();//连接数据库
                        int i = cmd.ExecuteNonQuery(); //执行数据库指令
                        con.Close();
                    }


                }


                


                if (System.IO.File.Exists("Temp/" + fileModel.FileName + "/Controllers/" + fileModel.FileName + "Controller.cs"))
                {
                    System.IO.File.Move("Temp/" + fileModel.FileName + "/Controllers/" + fileModel.FileName + "Controller.cs", "Modules/Controllers/" + fileModel.FileName + "Controllers.cs",true);
                }



                if (Directory.Exists("Temp/" + fileModel.FileName + "/Models/"))
                {
                    DirectoryInfo d = new DirectoryInfo("Temp/" + fileModel.FileName + "/Models/"); //Assuming Test is your Folder.
                    FileInfo[] Files = d.GetFiles("*.cs"); //Getting Text files
                    (new FileInfo("Modules/Models/" + fileModel.FileName + "/")).Directory.Create();
                    foreach (FileInfo file in Files)
                    {
                        System.IO.File.Move("Temp/" + fileModel.FileName + "/Models/" + file.Name , "Modules/Models/"+ fileModel.FileName+"/"+file.Name, true);
                    }

                } 
                


                
                    
                if (System.IO.File.Exists("Temp/" + fileModel.FileName + "/Html/" + fileModel.FileName + ".html"))
                {
                    System.IO.File.Move("Temp/" + fileModel.FileName + "/Html/" + fileModel.FileName + ".html", "wwwroot/Modules/Html/" + fileModel.FileName + ".html", true);
                }
                if (System.IO.File.Exists("Temp/" + fileModel.FileName + "/Css/" + fileModel.FileName + ".css"))
                {
                    System.IO.File.Move("Temp/" + fileModel.FileName + "/Css/" + fileModel.FileName + ".css", "wwwroot/Modules/Css/" + fileModel.FileName + ".css", true);
                }
                if (System.IO.File.Exists("Temp/" + fileModel.FileName + "/Js/" + fileModel.FileName + ".js"))
                {
                    System.IO.File.Move("Temp/" + fileModel.FileName + "/Js/" + fileModel.FileName + ".js", "wwwroot/Modules/Js/" + fileModel.FileName + ".js", true);
                }
                Directory.Delete("Temp/" + fileModel.FileName +"/" , true);
                return new ContentResult { Content = JsonSerializer.Serialize("module created"), StatusCode = 201 };
            }
            catch (Exception ex)
            {
                try
                {
                    Directory.Delete("Temp/" + fileModel.FileName + ".zip", true);
                    Directory.Delete("Temp/" + fileModel.FileName + "/", true);
                }
                catch { }
                return new ContentResult { Content = JsonSerializer.Serialize("module not created") + ex, StatusCode = 400 };
            }

        }
    }
}
