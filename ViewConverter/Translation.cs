using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ViewConverter {
    class Translation {
        public enum type_of_translation {
            GridSetting,
            SearchType,
            Criteria
        }
        public string key { get; set; }
        public string value { get; set; }
        public type_of_translation tip { get; set; }
        public Translation(string input, type_of_translation tip) {
            this.tip = tip;
            key = tip == type_of_translation.GridSetting ? input.Split('\n')[0].Split('=')[1].Trim() : "";
            value = input.Split('\n')[1];
            int en = value.IndexOf('"');
            int dv = value.LastIndexOf('"');
            value = value.Substring(value.IndexOf('"')+1, value.LastIndexOf('"')-value.IndexOf('"')-1);
        }
    }
}
