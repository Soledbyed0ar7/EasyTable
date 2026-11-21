using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace TCM.Models
{
    public class ConversorDataTable
    {
        public static Dictionary<String,object>[] paraDictArray(DataTable dt)
        {
            Dictionary<string, object>[] arr =
                new Dictionary<string, object>[dt.Rows.Count];

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                arr[i] = new Dictionary<string, object>();

                foreach (DataColumn coluna in dt.Columns)
                {
                    arr[i][coluna.ColumnName] = dt.Rows[i][coluna] == DBNull.Value
                    ? null
                    : dt.Rows[i][coluna];
                }
            }

            return arr;
        }
        public static Dictionary<string, object>[] ConversorPedidoProdutoSubProduto(DataTable dt)
        {
            Dictionary<int, Dictionary<string, object>> mapa =
                new Dictionary<int, Dictionary<string, object>>();

            List<Dictionary<string, object>> produtos =
                new List<Dictionary<string, object>>();

            foreach (DataRow linha in dt.Rows)
            {
                int idPedidoProduto =
                    Convert.ToInt32(linha["idPedidoProduto"]);

                // Cria o produto apenas uma vez
                if (!mapa.ContainsKey(idPedidoProduto))
                {
                    int quantidade = Convert.ToInt32(linha["quantidade"]);

                    decimal precoUnitario =
                        Convert.ToDecimal(linha["precoUnitarioFinal"]);

                    Dictionary<string, object> produto =
                        new Dictionary<string, object>();

                    produto.Add("idPedidoProduto", idPedidoProduto);
                    produto.Add("idProduto", Convert.ToInt32(linha["idProduto"]));
                    produto.Add("nome", linha["nome"]);
                    produto.Add("quantidade", quantidade);
                    produto.Add("precoUnitario", precoUnitario);
                    produto.Add("precoTotal", precoUnitario * quantidade);

                    produto.Add(
                        "alteracoes",
                        new List<Dictionary<string, object>>()
                    );

                    mapa.Add(idPedidoProduto, produto);
                    produtos.Add(produto);
                }

                // Verifica se existe subproduto nessa linha
                if (linha["idSubProduto"] != DBNull.Value)
                {
                    int quantidadePadrao =
                        Convert.ToInt32(linha["quantidadePadrao"]);

                    int quantidadeEscolhida =
                        Convert.ToInt32(linha["quantidadeEscolhida"]);

                    int diferenca =
                        quantidadeEscolhida - quantidadePadrao;

                    // Só adiciona se houve alteração
                    if (diferenca != 0)
                    {
                        List<Dictionary<string, object>> alteracoes =
                            (List<Dictionary<string, object>>)
                            mapa[idPedidoProduto]["alteracoes"];

                        Dictionary<string, object> alteracao =
                            new Dictionary<string, object>();

                        alteracao.Add(
                            "idSubProduto",
                            Convert.ToInt32(linha["idSubProduto"])
                        );

                        alteracao.Add("nome", linha["nomeSubProduto"]);
                        alteracao.Add("quantidade", diferenca);

                        alteracao.Add(
                            "precoUnitario",
                            Convert.ToDecimal(linha["precoSubProduto"])
                        );

                        alteracoes.Add(alteracao);
                    }
                }
            }

            return produtos.ToArray();
        }

    }
}