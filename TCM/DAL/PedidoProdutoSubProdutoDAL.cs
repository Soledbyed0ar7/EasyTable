using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TCM.DAL;
using TCM.Models;
using System.Data;

namespace TCM.DAL
{
    public class PedidoProdutoSubProdutoDAL
    {
        private static readonly BancoDados bd = new BancoDados();
        public static void criarPedidoProdutoSubProduto(int idPedidoProduto, int idSubProduto, int acao,decimal precoUnitario)
        {
            bd.Executar(
            @"INSERT INTO PedidoProduto_SubProduto (idPedidoProduto, idSubProduto, acao, precoUnitario)
              VALUES (@idPedidoProduto, @idSubProduto, @acao, @precoUnitario)",
            BancoDados.Param("@idPedidoProduto", idPedidoProduto),
            BancoDados.Param("@idSubProduto", idSubProduto),
            BancoDados.Param("@acao", acao),
            BancoDados.Param("@precoUnitario", precoUnitario)
        );
        }
        public static Dictionary<string, object>[] verCarrinho(int mesa)
        {
            DataTable dt = PedidoProdutoDAL.verCarrinho(mesa);

            return ConversorDataTable.ConversorPedidoProdutoSubProduto(dt);
        }
    }
}