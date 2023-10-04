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
using System.Text.Json;



// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace BeeAware.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        public UserController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost]
        [Route("register")]
        [ProducesResponseType(StatusCodes.Status202Accepted)] //回传给前端的状态
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        public ContentResult register(User user) //user指post内容
        {
            SqlConnection con = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());

            SqlCommand cmd = new SqlCommand("INSERT INTO glb_Users(UserName, Password, UserPoints, PostDate) VALUES('" + user.UserName + "','" + user.Password + "', 0, '"+ DateTime.Today + "')", con);
            con.Open();//连接数据库
            int i = 0;
            try {
                 i = cmd.ExecuteNonQuery(); //执行数据库指令
            }
            catch {
                return new ContentResult { Content = JsonSerializer.Serialize("server error"), StatusCode = 500 };
            }
            con.Close();
            if (i > 0)
            {
                return new ContentResult { Content = JsonSerializer.Serialize("register succeed"), StatusCode = 201 };
            }
            else
            {
                return new ContentResult { Content = JsonSerializer.Serialize("register fail"), StatusCode = 403 };
            }
        }

        [HttpPost]
        [Route("login")]
        [ProducesResponseType(StatusCodes.Status202Accepted)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public ContentResult login(User user)
        {
            SqlConnection con = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());
            SqlCommand cmd = new SqlCommand("SELECT * FROM glb_Users WHERE UserName = '" + user.UserName + "';", con);
            con.Open();
            SqlDataReader read = cmd.ExecuteReader();
            var result = new List<User>(); //上一步read转化成result
            while (read.Read())
            {
                User a_user = new User
                {
                    UserName = read.GetString(1),
                    Password = read.GetString(2),
                };
                result.Add(a_user);
            };
            read.Close();
            con.Close();
            if (!result.Any())
            {
                return new ContentResult { Content = JsonSerializer.Serialize("user not found"), StatusCode = 404 };//数据库回传为空
            }

            foreach (var a_user in result)
            {
                if (a_user.Password == user.Password) //验证密码
                {
                    HttpContext.Session.SetString(SessionVariables.SessionKeyUserEmail.ToString(), a_user.UserName);
                    //HttpContext.Session.SetString(SessionKeyEnum.SessionKeyUserGroup.ToString(), a_user.Group);
                    return new ContentResult { Content = JsonSerializer.Serialize(HttpContext.Session.GetString(SessionVariables.SessionKeyUserEmail)), StatusCode = 202 };
                }
            }
            return new ContentResult { Content = JsonSerializer.Serialize("incorrect password"), StatusCode = 403 };
        }

        [HttpGet]
        [Route("logout")]
        [ProducesResponseType(StatusCodes.Status202Accepted)]
        [ProducesResponseType(StatusCodes.Status403Forbidden)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public ContentResult logout()
        {
            HttpContext.Session.SetString(SessionVariables.SessionKeyUserEmail.ToString(), "no_user");
            return new ContentResult { Content = JsonSerializer.Serialize("logged out"), StatusCode = 202 };
            
        }

        [HttpGet]
        [Route("checkLogin")]
        [ProducesResponseType(StatusCodes.Status202Accepted)] //回传给前端的状态
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        public ContentResult checkLogin()
        {
            string currentUser = HttpContext.Session.GetString(SessionVariables.SessionKeyUserEmail);
            if (currentUser != null && currentUser != "no_user")
            {
                return new ContentResult { Content = JsonSerializer.Serialize(currentUser), StatusCode = 202 };
            }
            else
            {
                return new ContentResult { Content = JsonSerializer.Serialize("no logged in user"), StatusCode = 204 };

            }
        }
    }
}
