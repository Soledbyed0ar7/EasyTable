using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TCM.BLL;

namespace TCM
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void cadastrar_Click(object sender, EventArgs e)
        {
            String nome = user.Text;
            String pass  = senha.Text;
            if (FuncionarioBLL.LogarGarcom(nome, pass)) Response.Redirect("garcom.aspx");
            if (FuncionarioBLL.LogarCozinha(nome, pass)) Response.Redirect("cozinha.aspx");
            if (FuncionarioBLL.LogarBalcao(nome, pass)) Response.Redirect("balcao.aspx");
        }
    }
}