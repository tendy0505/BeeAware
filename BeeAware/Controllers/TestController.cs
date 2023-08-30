using Microsoft.AspNetCore.Mvc;
using System.Data.SqlClient;
using System.Text.Json;

namespace BeeAware.Controllers
{

    [Route("api/[controller]")]
    [ApiController]
    public class TestController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        public TestController(IConfiguration configuration)
        {
            _configuration = configuration;
        }
        [HttpGet]
        [Route("TestAward")]
        [ProducesResponseType(StatusCodes.Status200OK)] //回传给前端的状态
        public ContentResult TestAward()
        {
            SqlConnection con = new SqlConnection(_configuration.GetConnectionString("BeeAwareLogin").ToString());
            bool operation = BeeAware_Core.AddAwards(con, 34, 8);
            if (operation)
            {
                return new ContentResult{Content = JsonSerializer.Serialize(operation), StatusCode = 200 }; 
            } else{
                return new ContentResult { Content = JsonSerializer.Serialize(operation), StatusCode = 403 };
            }
        }


    }
}
