using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TCM.DAL;
using TCM.Models;
namespace TCM.BLL
{
    public class CozinhaBLL
    {
        public static Dictionary<String, object>[] infoPedido(int idMesa)
        {
            return ConversorDataTable.ConversorPedidoCozinha(PedidoProdutoDAL.verPedidoCozinha(idMesa));
        }
    }
}