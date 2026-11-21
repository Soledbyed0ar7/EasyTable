using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace TCM.DAL
{

    public class SubProdutoDAL
    {
        private static readonly BancoDados bd = new BancoDados();
        public static DataTable listarSubprodutos(int idProduto)
        {
            return bd.Consultar("SELECT sp.idSubProduto ,sp.nome ,sp.valor ,ps.quantidade FROM Produto_SubProduto ps INNER JOIN SubProduto sp ON ps.idSubProduto = sp.idSubProduto WHERE ps.idProduto = @idProduto; ", 
                BancoDados.Param("@idProduto",idProduto));
        }
        public static decimal verPrecoUnitario(int idSubProduto)
        {
            return Convert.ToDecimal(bd.ConsultarValor("SELECT valor from SubProduto where idSubProduto = @idSubproduto;", BancoDados.Param("@idSubproduto", idSubProduto)));
        }
    }
}