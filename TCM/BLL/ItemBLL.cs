using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TCM.DAL;
using System.Data;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

namespace TCM.BLL
{
    public class ItemBLL
    {

        public static void salvarItemNoPedido(Dictionary<String, object> dados, int mesa)
        {
            if (mesa == -1) return;
            if (dados == null) return;

            if (!dados.ContainsKey("idProduto")) return;
            if (!dados.ContainsKey("quantidade")) return;

            int idProduto = Convert.ToInt32(dados["idProduto"]);
            int quantidade = Convert.ToInt32(dados["quantidade"]);

            decimal precoUnitarioProduto = ProdutoDAL.verPrecoUnitario(idProduto);

            int idPedido = PedidoDAL.checarExistePedido(mesa);

            if (idPedido == -1)
            {
                idPedido = PedidoDAL.criarNovoPedido(mesa);
            }

            int idPedidoProduto = PedidoProdutoDAL.criarPedidoProduto(
                idPedido,
                idProduto,
                quantidade,
                precoUnitarioProduto
            );

            if (dados.TryGetValue("alteracoes", out var itensObj) &&
                itensObj is JArray itensArray)
            {
                var listaDeDicts =
                    itensArray.ToObject<List<Dictionary<string, object>>>();

                foreach (Dictionary<String, object> item in listaDeDicts)
                {
                    int idSubProduto = Convert.ToInt32(item["idSubProduto"]);
                    int acao = Convert.ToInt32(item["acao"]);

                    decimal precoUnitarioSubProduto =
                        SubProdutoDAL.verPrecoUnitario(idSubProduto);

                    PedidoProdutoSubProdutoDAL.criarPedidoProdutoSubProduto(
                        idPedidoProduto,
                        idSubProduto,
                        acao,
                        precoUnitarioSubProduto
                    );
                }
            }
        }

    }
}