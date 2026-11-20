using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using System.Threading.Tasks;
using System.Data;
using TCM.BLL;
using TCM.Models;
namespace TCM
{
    public class Hubs : Hub
    {
        BancoDados bd = new BancoDados();

        public int mesaQtde()
        {
            return MesaBLL.quantidadeDeMesas();
        }
        public object[] mesasUsadas()
        {
            return MesaBLL.quantidadeDeMesasUsadas();
        }
        public void reservarMesa(int num)
        {
            MesaBLL.reservarMesas(num);
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
        public int mesaCookie()
        {
            var cookie = HttpContext.Current.Request.Cookies["mesa"];
            if (cookie == null)
            {
                return -1;
            }
            return Convert.ToInt32(cookie.Value);
        }
        //atendimento
        public Dictionary<String, object>[] listarTodosProdutos()
        {
            return ProdutoBLL.listarTodosProdutos();
        }

        public Dictionary<String, object>[] listarSubprodutos(int idProduto)
        {
            return SubProdutoBLL.listarSubprodutos(idProduto);
        }
        public void salvarItemNoPedido(Dictionary<String, object> dados)
        {
            ItemBLL.salvarItemNoPedido(dados);
        }


        //Clients.All.ReceberMensagem(mensagem);
        //Clients.All.mesaReservadaAgora(1);


    }
}