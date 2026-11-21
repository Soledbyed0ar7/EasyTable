using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TCM.DAL;
using System.Data;

namespace TCM.BLL
{
    public class PedidoBLL
    {
        public static void MudarStatusPedido(int idMesa)
        {
            PedidoDAL.Npv(idMesa);
        }
    }
}