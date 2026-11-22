using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TCM.DAL;
using TCM.Models;

namespace TCM.BLL
{
    public class BalcaoBLL
    {
        public static Dictionary<String,object>[] infoPedidoBalcao(int idMesa)
        {
            return ConversorDataTable.ConversorPedidoBalcao(PedidoProdutoDAL.verPedidoBalcao(idMesa));
        }
        public static void fecharComanda(int idMesa)
        {
            PedidoDAL.fecharComanda(idMesa);
        }
    }
}