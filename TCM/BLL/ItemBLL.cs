using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TCM.DAL;
using System.Data;

namespace TCM.BLL
{
    public class ItemBLL
    {
        public static void salvarItemNoPedido(Dictionary<String, object> dados)
        {
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
            if (dados.ContainsKey("alteracoes"))
            {
                
            }
        }
    }
}