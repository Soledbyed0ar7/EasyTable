using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
namespace TCM.DAL
{
    public class ProdutoDAL
    {
        private static readonly BancoDados bd = new BancoDados();
        public static DataTable listarTodosProdutos()
        {
            DataTable dt = bd.Consultar("select * from Produto");
            return dt;
        }
        public static decimal verPrecoUnitario(int idProduto)
        {
            object objValor = bd.ConsultarValor("select valor from Produto where idProduto = @idProduto", 
                BancoDados.Param("@idProduto", idProduto));
            return Convert.ToDecimal(objValor);
        }
    }
}