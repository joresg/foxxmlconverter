using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace ViewConverter {
    class GridSetting {
        public string sql_field_name { get; set; }
        public string header_name { get; set; }
        public string control_type { get; set; }
        public int width { get; set; }
        public int sort_order { get; set; }
        public GridSetting(string input) {
            string[] lines = input.Split('\n');
            sql_field_name = lines[2].Split('=')[1].Trim();
            sql_field_name = sql_field_name.Substring(1,sql_field_name.Length-2);
            header_name = lines[3].Split('=')[1].Trim();
            control_type = lines[4].Split('=')[1].Trim();
            width = Int32.Parse(lines[5].Split('=')[1].Trim());
            sort_order = Int32.Parse(lines[13].Split('=')[1].Trim());
        }
    }
}
