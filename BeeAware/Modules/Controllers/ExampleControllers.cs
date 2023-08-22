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
    public class ExampleController : ControllerBase
    {
        private readonly IConfiguration _configuration; //dont change this line
        public ExampleController(IConfiguration configuration) // [ModuleName]Controller
        {
            _configuration = configuration;
        }
        

        [HttpGet] //depents on get or post function
        [Route("Test")] // the route to fetch as api/[ModuleName]/[Route]. e.g: This one is for api/Example/Test
        [ProducesResponseType(StatusCodes.Status200OK)] // passibile response
        public ContentResult Test()  // same method name as route
        {
           return new ContentResult { Content = JsonSerializer.Serialize("hello world"), StatusCode = 200 }; // { Content = JsonSerializer.Serialize([returnedElement]), StatusCode = [StatusCode] }; 
        }
    }

    /*[HttpGet]
    [Route("Check")]
    [ProducesResponseType(StatusCodes.Status200OK)] // passibile response
    public ContentResult Check()
    {
        SqlConnection con = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());

        SqlCommand cmd = new SqlCommand("select * from modules;", con);
        con.Open();
        SqlDataReader read = cmd.ExecuteReader();
        var result = new List<Module>(); 
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
            returned.Add(System.IO.File.ReadAllText("wwwroot/Modules/Html/"+module.Name+".html"));
        }

        return new ContentResult { Content = JsonSerializer.Serialize(returned), StatusCode = 200 };
    }*/
    // an example of a route function with sql command

}
