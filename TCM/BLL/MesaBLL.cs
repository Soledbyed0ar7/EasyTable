using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TCM.DAL;
using System.Data;

namespace TCM.BLL
{
    public class MesaBLL
    {
        public static int quantidadeDeMesas()
        {
            return MesaDAL.buscarQuantidadeDeMesas();
        }
        public static object[] quantidadeDeMesasUsadas()
        {
            DataTable dt = MesaDAL.buscarQuantidadeDeMesasUsadas();
            return dt.AsEnumerable().Select(row => row[0]).ToArray();
        }
        public static void reservarMesas(int num)
        {
            MesaDAL.reservarMesa(num);
        }
    }
}