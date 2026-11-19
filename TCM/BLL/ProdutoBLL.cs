using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TCM.DAL;
using TCM.Models;

namespace TCM.BLL
{
    public class ProdutoBLL
    {
        public static Dictionary<String, object>[] listarTodosProdutos()
        {
            Dictionary<String, object>[] arr = ConversorDataTable.paraDictArray(ProdutoDAL.listarTodosProdutos());
            return arr;
        }
    }
}