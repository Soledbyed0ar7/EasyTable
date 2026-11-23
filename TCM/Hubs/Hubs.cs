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
        public Task configAtendimento()
        {

            if (mesaCookie() == -1)
            {
                Clients.Caller.tomarBan();
            }
            return Groups.Add(Context.ConnectionId, mesaCookie().ToString());
        }
        public Task configGarcom()
        {
            var cookie = HttpContext.Current.Request.Cookies["permicao"];
            if (cookie == null || !(cookie.Value == "P"))
            {
                Clients.Caller.tomarBan();
            }
            return Groups.Add(Context.ConnectionId, "garcom");
        }
        public Task configCozinha()
        {
            var cookie = HttpContext.Current.Request.Cookies["permicao"];
            if (cookie == null || !(cookie.Value == "P"))
            {
                Clients.Caller.tomarBan();
            }
            return Groups.Add(Context.ConnectionId, "cozinha");
        }
        
        public void configBalcao()
        {
            var cookie = HttpContext.Current.Request.Cookies["permicao"];
            if (cookie == null || !(cookie.Value == "P"))
            {
                Clients.Caller.tomarBan();
            }

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
            int valorDoCookie = -1;
            if (Context.Request.Cookies.TryGetValue("mesa", out Cookie cookie))
            {
                valorDoCookie = Convert.ToInt32( cookie.Value);
                
                
            }
            ItemBLL.salvarItemNoPedido(dados,valorDoCookie);
        }
        public Dictionary<String,object>[] montarCarrinho()
        {
            int idMesa = mesaCookie();
            return ItemBLL.MostrarCarinho(idMesa);

        }
        public void finalizarPedido()
        {
            int idMesa = mesaCookie();
            PedidoBLL.MudarStatusPedido(idMesa);
            Clients.Group("garcom").avisarGarcons(idMesa);
        }
        public void avisarLiberacao(int idMesa, bool aviso)
        {
            if (aviso)
            {
                PedidoBLL.AprovarPedido(idMesa);
                Clients.Group("cozinha").mostrarNovoPedido(CozinhaBLL.infoPedido(idMesa), idMesa);
            }
            PedidoBLL.RecusarPedido(idMesa);
            


        }

        public Dictionary<String, object>[] visualizarComanda(int idMesa)
        {
            return BalcaoBLL.infoPedidoBalcao(idMesa);
        }
        public void fecharComanda(int idMesa)
        {
            BalcaoBLL.fecharComanda(idMesa);
            Clients.Group(idMesa.ToString()).tomarBan();
        }
        


        //Clients.All.ReceberMensagem(mensagem);
        //Clients.All.mesaReservadaAgora(1);


    }
}