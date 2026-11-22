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
        public static DataTable verCarrinho(int mesa)
        {
            return bd.Consultar(
                @"SELECT
            pp.idPedidoProduto,
            p.idProduto,
            p.nome,
            pp.quantidade,

            p.valor + SUM(
                CASE
                    WHEN
                        COALESCE(psp.quantidade, 0) + COALESCE(ppsp.acao, 0)
                        > COALESCE(psp.quantidade, 0)
                    THEN
                        COALESCE(ppsp.acao, 0) * COALESCE(sp.valor, 0)
                    ELSE
                        0
                END
            ) OVER (PARTITION BY pp.idPedidoProduto) AS precoUnitarioFinal,

            psp.idSubProduto,
            sp.nome AS nomeSubProduto,

            COALESCE(psp.quantidade, 0) AS quantidadePadrao,

            COALESCE(psp.quantidade, 0) + COALESCE(ppsp.acao, 0) AS quantidadeEscolhida,

            sp.valor AS precoSubProduto

        FROM Pedido ped

        INNER JOIN PedidoProduto pp
            ON ped.idPedido = pp.idPedido

        INNER JOIN Produto p
            ON pp.idProduto = p.idProduto

        LEFT JOIN Produto_SubProduto psp
            ON psp.idProduto = pp.idProduto

        LEFT JOIN SubProduto sp
            ON sp.idSubProduto = psp.idSubProduto

        LEFT JOIN PedidoProduto_SubProduto ppsp
            ON ppsp.idPedidoProduto = pp.idPedidoProduto
            AND ppsp.idSubProduto = psp.idSubProduto

        WHERE
            ped.idMesa = @idMesa
            AND ped.estadoPedido = 'N'

        ORDER BY pp.idPedidoProduto;",
                BancoDados.Param("@idMesa", mesa)
            );
        }
        public static DataTable verPedidoCozinha(int mesa)
        {
            return bd.Consultar(
                @"SELECT
            pp.idPedidoProduto,
            p.nome,
            pp.quantidade,

            sp.nome AS nomeSubProduto,
            ppsp.acao AS quantidadeAlteracao

        FROM Pedido ped

        INNER JOIN PedidoProduto pp
            ON ped.idPedido = pp.idPedido

        INNER JOIN Produto p
            ON pp.idProduto = p.idProduto

        LEFT JOIN PedidoProduto_SubProduto ppsp
            ON ppsp.idPedidoProduto = pp.idPedidoProduto
            AND ppsp.acao <> 0

        LEFT JOIN SubProduto sp
            ON sp.idSubProduto = ppsp.idSubProduto

        WHERE
            ped.idMesa = @idMesa
            AND ped.estadoPedido = 'P'

        ORDER BY pp.idPedidoProduto;",
                BancoDados.Param("@idMesa", mesa)
            );
        }
        public static DataTable verPedidoBalcao(int mesa)
        {
            return bd.Consultar(
                @"SELECT
            pp.idPedidoProduto,
            p.nome,
            pp.quantidade,

            CAST(
                (
                    COALESCE(pp.precoUnitario, 0)
                    +
                    COALESCE(
                        SUM(
                            CASE
                                WHEN ppsp.acao > 0
                                THEN
                                    ppsp.acao * COALESCE(sp.valor, 0)
                                ELSE
                                    0
                            END
                        ) OVER (
                            PARTITION BY pp.idPedidoProduto
                        ),
                        0
                    )
                ) * pp.quantidade
                AS DECIMAL(10,2)
            ) AS valorTotal,

            sp.nome AS nomeSubProduto,
            ppsp.acao AS quantidadeAlteracao

        FROM Pedido ped

        INNER JOIN PedidoProduto pp
            ON ped.idPedido = pp.idPedido

        INNER JOIN Produto p
            ON pp.idProduto = p.idProduto

        LEFT JOIN PedidoProduto_SubProduto ppsp
            ON ppsp.idPedidoProduto = pp.idPedidoProduto
            AND ppsp.acao <> 0

        LEFT JOIN SubProduto sp
            ON sp.idSubProduto = ppsp.idSubProduto

        WHERE
            ped.idMesa = @idMesa
            AND ped.estadoPedido IN ('P', 'E')

        ORDER BY pp.idPedidoProduto;",
                BancoDados.Param("@idMesa", mesa)
            );
        }
    }
}