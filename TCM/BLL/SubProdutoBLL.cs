using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TCM.DAL;
using System.Data;
using TCM.Models;

namespace TCM.BLL
{
    public class SubProdutoBLL
    {
        public static Dictionary<String, object>[] listarSubprodutos(int idProduto)
        {
            return ConversorDataTable.paraDictArray(SubProdutoDAL.listarSubprodutos(idProduto));
        }
        
    }
}