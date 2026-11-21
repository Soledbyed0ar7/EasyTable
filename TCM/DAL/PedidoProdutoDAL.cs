using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace TCM.DAL
{
    
    public class PedidoProdutoDAL
    {
        private static readonly BancoDados bd = new BancoDados();
        public static int criarPedidoProduto(int idPedido, int idProduto, int quantidade, decimal precoUnitario)
        {
            int idPedidoProduto = Convert.ToInt32(bd.ConsultarValor(
                    @"INSERT INTO PedidoProduto (idPedido, idProduto, quantidade, precoUnitario)
                      OUTPUT INSERTED.idPedidoProduto
                      VALUES (@idPedido, @idProduto, @quantidade, @precoUnitario)",
                    BancoDados.Param("@idPedido", idPedido),
                    BancoDados.Param("@idProduto", idProduto),
                    BancoDados.Param("@quantidade", quantidade),
                    BancoDados.Param("@precoUnitario", precoUnitario)
                 ));
            return idPedidoProduto;
        }
    }
}