using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace TCM.Models
{
    public class ConversorDataTable
    {
        public static Dictionary<String,object>[] paraDictArray(DataTable dt)
        {
            Dictionary<string, object>[] arr =
                new Dictionary<string, object>[dt.Rows.Count];

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                arr[i] = new Dictionary<string, object>();

                foreach (DataColumn coluna in dt.Columns)
                {
                    arr[i][coluna.ColumnName] = dt.Rows[i][coluna];
                }
            }

            return arr;
        }
    }
}