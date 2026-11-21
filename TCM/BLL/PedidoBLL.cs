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
        public static void AprovarPedido(int idMesa)
        {
            PedidoDAL.VpP(idMesa);
        }
        public static void RecusarPedido(int idMesa)
        {
            PedidoDAL.VpC(idMesa);
        }
    }

}