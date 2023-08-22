using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;
using BeeAware.Models;
using System.Reflection.PortableExecutable;
using Microsoft.AspNetCore.Session;
using Microsoft.AspNetCore.Http;
using static BeeAware.SessionVariables;
using System.Net.Http;
using System.Net;
using System;
using System.IO;
using System.Text;
using System.Text.Json;


// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BeeAware.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ModuleController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        public ModuleController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        [Route("Check")]
        [ProducesResponseType(StatusCodes.Status200OK)] //回传给前端的状态
        public ContentResult Check()
        {
            SqlConnection con = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());

            SqlCommand cmd = new SqlCommand("select * from modules;", con);
            con.Open();
            SqlDataReader read = cmd.ExecuteReader();
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
            con.Close();
            List<string> returned = new List<string> { };
            foreach (var module in result)
            {

                returned.Add(System.IO.File.ReadAllText("wwwroot/Modules/Html/" + module.Name + ".html"));
            }

            return new ContentResult { Content = JsonSerializer.Serialize(returned), StatusCode = 200 };
        }

        [HttpGet]
        [Route("List")]
        [ProducesResponseType(StatusCodes.Status200OK)] //回传给前端的状态
        public ContentResult List()
        {
            SqlConnection con = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());

            SqlCommand cmd = new SqlCommand("select * from modules;", con);
            con.Open();
            SqlDataReader read = cmd.ExecuteReader();
            var result = new List<Module>(); //上一步read转化成result
            while (read.Read())
            {
                var a_module = new Module
                {
                    Id = read.GetInt32(0),
                    Name = read.GetString(1),
                    Description = read.GetString(2),
                    tableUse = read.GetString(3),
                };
                result.Add(a_module);
            };
            read.Close();
            con.Close();
            return new ContentResult { Content = JsonSerializer.Serialize(result), StatusCode = 200 };
        }
        [HttpPost]
        [Route("Delete")]
        [ProducesResponseType(StatusCodes.Status200OK)] //回传给前端的状态
        public ContentResult Delete(Module module)
        {


            try
            {
                SqlConnection con = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());
                SqlCommand cmd = new SqlCommand("DELETE FROM modules WHERE Name = '" + module.Name + "'", con);
                con.Open();//连接数据库
                int i = cmd.ExecuteNonQuery(); //执行数据库指令
                con.Close();
                if (i <= 0)
                {
                    throw new Exception();
                }
            }
            catch
            {
                return new ContentResult { Content = JsonSerializer.Serialize("delete failed"), StatusCode = 403 };
            }

            try
            {
                SqlConnection con = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());
                SqlCommand cmd = new SqlCommand("DROP TABLE " + module.Name, con);
                con.Open();//连接数据库
                int i = cmd.ExecuteNonQuery(); //执行数据库指令
                con.Close();
                if (i <= 0)
                {
                    throw new Exception();
                }
            }
            catch
            {
            }

            if (System.IO.File.Exists("Modules/Controllers/" + module.Name + "Controllers.cs"))
            {
                System.IO.File.Delete("Modules/Controllers/" + module.Name + "Controllers.cs");
            }
            if (Directory.Exists("Modules/Models/" + module.Name + "/"))
            {
                Directory.Delete("Modules/Models/" + module.Name + "/", true);
            }
            if (System.IO.File.Exists("wwwroot/Modules/Html/" + module.Name + ".html"))
            {
                System.IO.File.Delete("wwwroot/Modules/Html/" + module.Name + ".html");
            }
            if (System.IO.File.Exists("wwwroot/Modules/Css/" + module.Name + ".css"))
            {
                System.IO.File.Delete("wwwroot/Modules/Css/" + module.Name + ".css");
            }
            if (System.IO.File.Exists("wwwroot/Modules/Js/" + module.Name + ".js"))
            {
                System.IO.File.Delete("wwwroot/Modules/Js/" + module.Name + ".js");
            }
            return new ContentResult { Content = JsonSerializer.Serialize("delete success"), StatusCode = 200 };

        }
    }
}
