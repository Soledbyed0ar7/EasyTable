using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace TCM.DAL
{
    public class PedidoDAL
    {
        private static readonly BancoDados bd = new BancoDados();
        public static int criarNovoPedido(int idMesa)
        {
            object resultado = bd.ConsultarValor(
            @"INSERT INTO Pedido (idMesa, estadoPedido, desconto)
              OUTPUT INSERTED.idPedido
              VALUES (@idMesa, @estadoPedido, @desconto)",
            BancoDados.Param("@idMesa", idMesa),
            BancoDados.Param("@estadoPedido", "N"),
            BancoDados.Param("@desconto", Convert.ToDecimal(10.00))
            );
            return Convert.ToInt32(resultado);
        }
        public static int checarExistePedido(int IdMesa)
        {
            object objidPedido = bd.ConsultarValor("select idPedido from Pedido where idMesa = @idMesa and estadoPedido ='N'",
                BancoDados.Param("@idMesa", IdMesa));
            if (objidPedido == null)
            {
                return -1;
            }
            int idPedido = Convert.ToInt32(objidPedido);
            return idPedido;
        }
    }
}