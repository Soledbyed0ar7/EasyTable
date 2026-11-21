using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TCM.Tests
{
    public partial class featuresSalvarBancoPedido : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnTestar_Click(object sender, EventArgs e)
        {
            string resultado = TesteItem.ExecutarTeste(1);

            lblResultado.Text = resultado.Replace(
                Environment.NewLine, "<br/>");
        }
    }
}