using Microsoft.AspNetCore.Http;

namespace WebApplication1.Models
{
    public class FileModel
    {
        public string FileName { get; set; }
        public IFormFile file { get; set; }  
    }
}
