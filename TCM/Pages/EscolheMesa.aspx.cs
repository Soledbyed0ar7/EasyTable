using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;

namespace TCM
{
    public partial class index : System.Web.UI.Page
    {
        
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }
        [System.Web.Services.WebMethod]
        public static void SelecionarMesa(int mesaId)
        {

            HttpCookie cookie = new HttpCookie("mesa");

            cookie.Value = mesaId.ToString();
            cookie.Expires = DateTime.Now.AddHours(5);
            cookie.Path = "/";
            HttpContext.Current.Response.Cookies.Add(cookie);
        }
        [System.Web.Services.WebMethod]
        public static void DeselecionarMesa(int mesaId)
        {
            HttpCookie cookie = new HttpCookie("mesa");
            cookie.Expires = DateTime.Now.AddDays(-1);
            HttpContext.Current.Response.Cookies.Add(cookie);
        }
    }
}