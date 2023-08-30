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
            SqlCommand cmd = new SqlCommand("select * from glb_SecMod", con);
            con.Open();
            SqlDataReader read = cmd.ExecuteReader();
            var result = new List<Module>(); //上一步read转化成result
            while (read.Read())
            {
                Module a_module = new Module
                {
                    _Module = read.GetString(1),
                    ModuleCode = read.GetString(2),

                };
                result.Add(a_module);
            };
            read.Close();
            con.Close();
            List<string> returned = new List<string> { };
            foreach (var module in result)
            {
                returned.Add(System.IO.File.ReadAllText("wwwroot/Modules/Html/" + module._Module + ".html"));
            }
            return new ContentResult { Content = JsonSerializer.Serialize(returned), StatusCode = 200 };
        }

        [HttpGet]
        [Route("List")]
        [ProducesResponseType(StatusCodes.Status200OK)] //回传给前端的状态
        public ContentResult List()
        {
            SqlConnection con = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());
            SqlCommand cmd = new SqlCommand("select * from glb_SecMod;", con);
            con.Open();
            SqlDataReader read = cmd.ExecuteReader();
            var result = new List<Module>(); //上一步read转化成result
            while (read.Read())
            {
                var a_module = new Module
                {
                    _Module = read.GetString(1),
                    ModuleCode = read.GetString(2),
                    Description = read.GetString(3),
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
            SqlConnection con = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());
            try
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM glb_SecMod WHERE Module = '" + module._Module + "'", con);
                con.Open();//连接数据库
                int i = cmd.ExecuteNonQuery(); //执行数据库指令
                con.Close();
                if (i <= 0)
                {
                    throw new Exception();
                }
                SqlCommand cmd2 = new SqlCommand("DECLARE @cmd varchar(4000)\r\nDECLARE cmds CURSOR FOR\r\nSELECT 'drop table [' + Table_Name + ']'\r\nFROM INFORMATION_SCHEMA.TABLES\r\nWHERE Table_Name LIKE '" + module._Module + "_%'\r\n\r\nOPEN cmds\r\nWHILE 1 = 1\r\nBEGIN\r\n    FETCH cmds INTO @cmd\r\n    IF @@fetch_status != 0 BREAK\r\n    EXEC(@cmd)\r\nEND\r\nCLOSE cmds;\r\nDEALLOCATE cmds ", con);
                con.Open();//连接数据库
                int i2 = cmd2.ExecuteNonQuery(); //执行数据库指令
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

            // database

            if (Directory.Exists("Modules/Controllers/" + module._Module + "/"))
            {
                Directory.Delete("Modules/Controllers/" + module._Module + "/", true);
            }
            if (Directory.Exists("Modules/Models/" + module._Module + "/"))
            {
                Directory.Delete("Modules/Models/" + module._Module + "/", true);
            }

            if (Directory.Exists("wwwroot/Modules/Files" + module._Module + "/"))
            {
                Directory.Delete("wwwroot/Modules/Files" + module._Module + "/", true);
            }
            if (System.IO.File.Exists("wwwroot/Modules/Html/" + module._Module + ".html"))
            {
                System.IO.File.Delete("wwwroot/Modules/Html/" + module._Module + ".html");
            }
            if (System.IO.File.Exists("wwwroot/Modules/Css/" + module._Module + ".css"))
            {
                System.IO.File.Delete("wwwroot/Modules/Css/" + module._Module + ".css");
            }
            if (System.IO.File.Exists("wwwroot/Modules/Js/" + module._Module + ".js"))
            {
                System.IO.File.Delete("wwwroot/Modules/Js/" + module._Module + ".js");
            }
            return new ContentResult { Content = JsonSerializer.Serialize("delete success"), StatusCode = 200 };

        }
    }
}
