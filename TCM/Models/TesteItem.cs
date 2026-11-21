
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using Newtonsoft.Json.Linq;
using TCM.DAL;
using TCM.BLL;
namespace TCM
{
    public class TesteItem
    {
        private static readonly BancoDados bd = new BancoDados();

        public static string ExecutarTeste(int mesa)
        {
            int idProduto = 1;

            // 1. CONSULTA ANTES
            DataTable antes = ConsultarItens(mesa, idProduto);

            // 2. MONTA OS DADOS COMO O FRONT ENVIARIA
            Dictionary<string, object> dados =
                new Dictionary<string, object>();

            dados.Add("idProduto", 1);
            dados.Add("quantidade", 2);

            dados.Add("alteracoes", JArray.Parse(@"
        [
            {
                'idSubProduto': 10,
                'acao': -1
            },
            {
                'idSubProduto': 15,
                'acao': 1
            }
        ]"));

            // 3. CHAMA A BLL DIRETAMENTE
            ItemBLL.salvarItemNoPedido(dados, mesa);

            // 4. CONSULTA DEPOIS
            DataTable depois = ConsultarItens(mesa, idProduto);

            // 5. MONTA O RESULTADO
            StringBuilder resultado = new StringBuilder();

            resultado.AppendLine("========== ANTES ==========");
            resultado.AppendLine(ExibirTabela(antes));

            resultado.AppendLine();
            resultado.AppendLine("========== DEPOIS ==========");
            resultado.AppendLine(ExibirTabela(depois));

            resultado.AppendLine();
            resultado.AppendLine(
                "Quantidade de registros antes: " + antes.Rows.Count);

            resultado.AppendLine(
                "Quantidade de registros depois: " + depois.Rows.Count);

            return resultado.ToString();
        }

        private static DataTable ConsultarItens(int mesa, int idProduto)
        {
            return bd.Consultar(@"
            SELECT
                p.idPedido,
                pp.idPedidoProduto,
                pp.idProduto,
                pp.quantidade,
                pp.precoUnitario,
                ppsp.idSubProduto,
                ppsp.acao,
                ppsp.precoUnitario AS precoSubProduto
            FROM Pedido p
            INNER JOIN PedidoProduto pp
                ON p.idPedido = pp.idPedido
            LEFT JOIN PedidoProduto_SubProduto ppsp
                ON pp.idPedidoProduto = ppsp.idPedidoProduto
            WHERE p.idMesa = @idMesa
              AND pp.idProduto = @idProduto
              AND p.estadoPedido = 'N'
            ORDER BY pp.idPedidoProduto, ppsp.idSubProduto",
                BancoDados.Param("@idMesa", mesa),
                BancoDados.Param("@idProduto", idProduto)
            );
        }

        private static string ExibirTabela(DataTable tabela)
        {
            StringBuilder sb = new StringBuilder();

            foreach (DataRow linha in tabela.Rows)
            {
                foreach (DataColumn coluna in tabela.Columns)
                {
                    sb.Append(coluna.ColumnName);
                    sb.Append(": ");
                    sb.Append(linha[coluna] == DBNull.Value
                        ? "NULL"
                        : linha[coluna].ToString());
                    sb.Append(" | ");
                }

                sb.AppendLine();
            }

            if (tabela.Rows.Count == 0)
                sb.AppendLine("Nenhum registro encontrado.");

            return sb.ToString();
        }
    }
}