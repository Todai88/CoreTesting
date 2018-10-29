using Microsoft.AspNetCore.Mvc;
using System.Text.Encodings.Web;

namespace Testcore.Controllers
{
    public class HomeController : Controller
    {
        // 
        // GET: /HelloWorld/

        public string Index()
        {
            return "This is my default action v2...";
        }

        // 
        // GET: /HelloWorld/Welcome/ 

        public string Welcome()
        {
            return "This is the Welcome action method...";
        }
    }
}