using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace TCM.DAL
{
    public class MesaDAL
    {
        private static readonly BancoDados bd = new BancoDados();
        public static int buscarQuantidadeDeMesas()
        {
            
            return Convert.ToInt32(bd.ConsultarValor("select count(*) from Mesa"));
        }
        public static DataTable buscarQuantidadeDeMesasUsadas()
        {
            return bd.Consultar("select idMesa from Mesa where estadoMesa like 'O'");
        }
        public static void reservarMesa(int num)
        {
            bd.Executar("update Mesa set estadoMesa ='O' where idMesa = @id",
                BancoDados.Param("@id", num)
                );
        }
        
    }
}