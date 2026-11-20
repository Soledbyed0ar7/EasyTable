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
            int idProduto;
            int quantidade;
            Dictionary<String, object>[] alteracoes;
            if (dados.ContainsKey("idProduto"))
            {
                idProduto = Convert.ToInt32(dados["idProduto"]);
            }
            if (dados.ContainsKey("quantidade"))
            {
                quantidade = Convert.ToInt32(dados["quantidade"]);
            }
            if (dados.TryGetValue("itens", out var itensObj) && itensObj is JArray itensArray)
            {
                var listaDeDicts = itensArray.ToObject<List<Dictionary<string, object>>>();
                int idPedido = PedidoDAL.checarExistePedido(mesa);
                if (idPedido == -1)
                {
                    idPedido = PedidoDAL.criarNovoPedido(mesa);
                }

            }
        }
    }
}