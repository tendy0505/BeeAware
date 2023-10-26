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
                
                string zipPath = Path.Combine("Temp/" + fileModel.FileName+".zip");
                string folderPath = Path.Combine("Temp/" + fileModel.FileName + "/");
                

                using (Stream stream = new FileStream(zipPath, FileMode.Create))
                {
                    fileModel.file.CopyTo(stream);
                }
                
                if (System.IO.File.Exists(folderPath))
                {
                    System.IO.File.Delete(folderPath);
                }

                
                ZipFile.ExtractToDirectory(zipPath, folderPath);
                // read the file and extract

                ModuleInfo? moduleInfo = JsonSerializer.Deserialize<ModuleInfo>(System.IO.File.ReadAllText(folderPath + "info.json"));
                // read the infomation

                if (moduleInfo==null||moduleInfo.Module == null||moduleInfo.ModuleCode == null || moduleInfo.Description==null || moduleInfo.SecurityLevel==null) {
                    throw new Exception();
                }
                // check json

                SqlConnection con = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());
                SqlCommand cmd3 = new SqlCommand("Select * from glb_SecMod where Module = '" + moduleInfo.Module + "'", con);
                con.Open();
                SqlDataReader read = cmd3.ExecuteReader();
                bool moduleExsit = false;
                while (read.Read())
                {
                    moduleExsit = true;
                };
                read.Close();
                con.Close();
                //check new


                if (Directory.Exists(folderPath + "Controllers/"))
                {
                    DirectoryInfo d = new DirectoryInfo(folderPath + "Controllers/"); 
                    FileInfo[] Files = d.GetFiles("*.cs"); //Getting Cs files
                    string distFolder = "Modules/Controllers/" + moduleInfo.Module + "/";
                    (new FileInfo(distFolder)).Directory.Create();
                    foreach (FileInfo file in Files)
                    {
                        System.IO.File.Move(folderPath + "Controllers/" + file.Name, distFolder + file.Name, true);
                    }
                }
                // put controllers (files)

                if (Directory.Exists(folderPath + "Models/"))
                {
                    DirectoryInfo d = new DirectoryInfo(folderPath + "Models/"); 
                    FileInfo[] Files = d.GetFiles("*.cs"); //Getting Cs files
                    string distFolder = "Modules/Models/" + moduleInfo.Module + "/";
                    (new FileInfo(distFolder)).Directory.Create();
                    foreach (FileInfo file in Files)
                    {
                        System.IO.File.Move(folderPath + "Models/" + file.Name, distFolder + file.Name, true);
                    }
                }
                // put models (files)

                if (Directory.Exists(folderPath + "Images/"))
                {
                    DirectoryInfo d = new DirectoryInfo(folderPath + "Images/");
                    FileInfo[] Files = d.GetFiles("*.jpg"); //Getting image files
                    string distFolder = "wwwroot/Modules/Images/"  + moduleInfo.Module + "/";
                    (new FileInfo(distFolder)).Directory.Create();
                    foreach (FileInfo file in Files)
                    {
                        System.IO.File.Move(folderPath + "Images/" + file.Name, distFolder + file.Name, true);
                    }
                    FileInfo[] Files2 = d.GetFiles("*.png"); //Getting image files
                    (new FileInfo(distFolder)).Directory.Create();
                    foreach (FileInfo file in Files2)
                    {
                        System.IO.File.Move(folderPath + "Images/" + file.Name, "wwwroot/Modules/Images/" + file.Name, true);
                    }
                }
                if (System.IO.File.Exists(folderPath + "/Html/" + moduleInfo.Module + ".html"))
                {
                    System.IO.File.Move(folderPath + "/Html/" + moduleInfo.Module + ".html", "wwwroot/Modules/Html/" + moduleInfo.Module + ".html", true);
                }
                if (System.IO.File.Exists(folderPath + "/Css/" + moduleInfo.Module + ".css"))
                {
                    System.IO.File.Move(folderPath + "/Css/" + moduleInfo.Module + ".css", "wwwroot/Modules/Css/" + moduleInfo.Module + ".css", true);
                }   
                if (System.IO.File.Exists(folderPath + "/Js/" + moduleInfo.Module + ".js"))
                {
                    System.IO.File.Move(folderPath + "/Js/" + moduleInfo.Module + ".js", "wwwroot/Modules/Js/" + moduleInfo.Module + ".js", true);
                }
                // put front-end (single file for each)


                Directory.Delete("Temp/" + fileModel.FileName +"/" , true);

                if (!moduleExsit) //new
                {

                    SqlCommand cmd2 = new SqlCommand("INSERT INTO glb_SecMod (Module, ModuleCode, Description, SecurityLevel)VALUES('" + moduleInfo.Module + "','" + moduleInfo.ModuleCode + "','" + moduleInfo.Description + "'," + moduleInfo.SecurityLevel + ");", con);
                    con.Open();//连接数据库
                    int i2 = cmd2.ExecuteNonQuery(); //执行数据库指令
                    con.Close();
                    if (i2 <= 0)
                    {
                        throw new Exception(); //if fail
                    }


                    if (moduleInfo.SQL != "" && moduleInfo.SQL != null)
                    {
                        SqlCommand cmd = new SqlCommand(moduleInfo.SQL, con);
                        con.Open();//连接数据库
                        int i = cmd.ExecuteNonQuery(); //执行数据库指令
                        con.Close();
                    }
                }
                else // update
                {
                    SqlCommand cmd2 = new SqlCommand("UPDATE [dbo].[glb_SecMod]\r\n   SET [ModuleCode] = '" + moduleInfo.ModuleCode + "'\r\n      ,[Description] = '" + moduleInfo.Description + "'\r\n      ,[SecurityLevel] = " + moduleInfo.SecurityLevel + "\r\n WHERE [Module] = '" + moduleInfo.Module + "'", con);
                    con.Open();//连接数据库
                    int i2 = cmd2.ExecuteNonQuery(); //执行数据库指令
                    con.Close();
                    if (i2 <= 0)
                    {
                        throw new Exception(); //if fail
                    }
                }
                // database
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
