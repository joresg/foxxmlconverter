using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace ViewConverter {
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window {
        public string foxCode { get; set; }
        public string sql_from_sp {get; set;}
        public string sql_from_select {get; set;}
        public MainWindow() {
            InitializeComponent();
            //sql_conn_string = @"Data Source = razvoj5\develop; Initial Catalog = Nova_Develop_develop; Integrated security = SSPI; Connection Timeout = 3000";
            /*
            using(sql_conn = new SqlConnection(sql_conn_string)) {
                sql_conn.InfoMessage += new SqlInfoMessageEventHandler(sqlGetPrint);
            }
            */
        }
        private void fox2xml(object sender, RoutedEventArgs e) {
            foxCode = fox_code.Text;
            convertFox2Xml(foxCode);
        }
        public void convertFox2Xml(string input) {
            //see if sql is select statement or stored procedure
            string pattern = @"SearchType\s*\[\s*i, 10\]\s*=\s*\d*";
            System.Text.RegularExpressions.Regex rgx = new System.Text.RegularExpressions.Regex(pattern);
            Match x = rgx.Match(input);
            int sql_type = Int32.Parse(x.Value.Split('=')[1]);

            //xml_code.Text = input;
            string form_name = "kek";
            string title = "analiticnikontniplan";
            string permission = "nekPerm";
            string licence_module = "";
            string run_default_search = "true";
            string hide_criteria_after_init = "true";
            string id_column = "konto";
            string xmlns = "urn:gmi:common:nova_client";
            StringBuilder sb = new StringBuilder();
            sb.Append(@"<?xml version=""1.0"" encoding=""utf - 8""?>");
            sb.Append("\n");
            sb.Append(@"<data_grid_form_definition");
            sb.Append("\n");
            sb.Append($@"name=""{form_name}""");
            sb.Append("\n");
            sb.Append($@"title=$""{title}""");
            sb.Append("\n");
            sb.Append($@"permission=""{permission}""");
            sb.Append("\n");
            sb.Append($@"licence_module=""{licence_module}""");
            sb.Append("\n");
            sb.Append($@"run_default_search=""{run_default_search}""");
            sb.Append("\n");
            sb.Append($@"hide_criteria_after_init=""{hide_criteria_after_init}""");
            sb.Append("\n");
            sb.Append($@"id_column=""{id_column}""");
            sb.Append("\n");
            sb.Append($@"xmlns=""{xmlns}""");
            sb.Append("\n");
            sb.Append(">");
            sb.Append("\n");
            sb.Append("TRANSLATION KEY TODO");
            sb.Append("\n");
            GridColumns(sb, input);
            SqlStatement(sb, sql_type, input);

            xml_code.Text = sql_type == 1 ? sb.ToString().Replace("{sql_placeholder}", sql_from_sp) : sb.ToString().Replace("{sql_placeholder}", sql_from_select);

        }
        public void GridColumns(StringBuilder sb, string input) {
            //string pattern = @"GridSettings\s*\[\s*i, [3|4]\]\s*=\s*"".*""";
            string pattern = @"GridSettings\s*\[\s*i, 1\]\s*=\s*\w*.*?GridSettings\s*\[\s*i, 15\]\s*=\s*\d*";

            //string pattern = @"GridSettings\s*\[\s*i, 1\]\s*=\s*\w*";
            System.Text.RegularExpressions.Regex rgx = new System.Text.RegularExpressions.Regex(pattern, RegexOptions.Singleline);
            MatchCollection x = rgx.Matches(input);

            List<GridSetting> grid_setting_list = new List<GridSetting>();
            sb.Append("hejehj\n");
            foreach(Match match in x) {
                grid_setting_list.Add(new GridSetting(match.Value));

            }
            foreach(GridSetting gs in grid_setting_list) {
                //sb.Append($@"<translation key={gs.sql_field_name} value={gs.header_name} />");
                string type = gs.control_type.Equals(@"""TextBox""") ? "string" : "boolean";
                sb.Append($@" <grid_column name=""{gs.sql_field_name}"" type={type} title=""${gs.sql_field_name}"" width=""{gs.width}"" format="""" default_sort_order=""{gs.sort_order}"" is_visible_by_default=""TODO"" />");
                sb.Append("\n");
            }

        }
        
        public void SqlStatement(StringBuilder sb, int type, string input) {
            sb.Append(@"<sql_template><![CDATA[");
            sb.Append("\n");
            //sql statement here
            sb.Append("{sql_placeholder}");
            sb.Append("\n");
            sb.Append(@"]]></sql_template>");
            sb.Append("\n");
            string sql_conn_string = @"Data Source = razvoj5\develop; Initial Catalog = Nova_Develop_develop; Integrated security = SSPI; Connection Timeout = 3000000";
            if (type == 1) {
                Console.WriteLine("stored procedure");
                string pattern = @"SearchType\s*\[\s*i\s*,\s*3\]\s*=\s*""[\w.\s]*""";
                System.Text.RegularExpressions.Regex rgx = new System.Text.RegularExpressions.Regex(pattern);
                Match x = rgx.Match(input);
                string sp_name = x.Value.Split('=')[1];
                sp_name = sp_name.Substring(2, sp_name.Length - 3);
                string query_string = $@"DECLARE @Lines TABLE (Line NVARCHAR(MAX)) ; DECLARE @FullText NVARCHAR(MAX) = ''; INSERT @Lines EXEC sp_helptext '{sp_name}'; SELECT @FullText = @FullText + Line FROM @Lines; PRINT @FullText; ";
                using (SqlConnection sql_con = new SqlConnection(sql_conn_string)) {
                    sql_con.InfoMessage += new SqlInfoMessageEventHandler(sqlGetPrint);
                    SqlCommand command = new SqlCommand(query_string, sql_con);
                    sql_con.Open();
                    command.ExecuteNonQuery();
                }
            }
            if(type == 2) {
                Console.WriteLine("Select statement");
                string pattern = @"SearchType\s*\[\s*i, 3\]\s*=\s*\b\w*\b*";
                System.Text.RegularExpressions.Regex rgx = new System.Text.RegularExpressions.Regex(pattern);
                Match x = rgx.Match(input);
                string sql_var_name = x.Value.Split('=')[1].Trim();
                //search for the value that this variable holds
                pattern = $@"TEXT\s*TO\s*{sql_var_name}\s*NOSHOW(.*?)ENDTEXT";
                rgx = new System.Text.RegularExpressions.Regex(pattern, RegexOptions.Singleline);
                x = rgx.Match(input);
                sql_from_select = x.Value;
            }
        }
        void sqlGetPrint(object sender, SqlInfoMessageEventArgs e) {
            sql_from_sp = e.Message;
        }
    }
}
