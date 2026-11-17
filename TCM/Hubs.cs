using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
namespace TCM
{
    public class Hubs : Hub
    {
        BancoDados bd = new BancoDados();

        public int mesaQtde()
        {
            return Convert.ToInt32(bd.ConsultarValor("select count(*) from Mesa"));
        }
        public object[] mesasUsadas()
        {
            DataTable dt = bd.Consultar("select idMesa from Mesa where estadoMesa like 'O'");
            return dt.AsEnumerable().Select(row => row[0]).ToArray();
        }
        public void reservarMesa(int num)
        {
            bd.Executar("update Mesa set estadoMesa ='O' where idMesa = @id", 
                BancoDados.Param("@id",num)
                );
            Clients.Group("ReservandoMesa").mesaReservadaAgora(num);
        }
        public Task configurarTelaReservarMesa()
        {
            return Groups.Add(Context.ConnectionId, "ReservandoMesa");
        }

        public void liberarMesa(int num)
        {
            bd.Executar("update Mesa set estadoMesa = 'L' where idMesa = @id",
                BancoDados.Param("@id", num));

            Clients.Group("ReservandoMesa").mesaLiberadaAgora(num);
        }

        //Clients.All.ReceberMensagem(mensagem);
        //Clients.All.mesaReservadaAgora(1);


    }
}