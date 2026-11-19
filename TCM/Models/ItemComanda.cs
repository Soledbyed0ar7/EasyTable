using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TCM.Models
{
    public class ItemComanda
    {
        public int idProduto { get; set; }
        public int quantidade { get; set; }

        public List<AlteracaoSubProduto> alteracoes { get; set; }
    }
}