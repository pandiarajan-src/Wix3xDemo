using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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

namespace Wix3xDemoWPF
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            this.WindowStartupLocation = WindowStartupLocation.CenterScreen;

        }

        private void Window_MouseMove(object sender, MouseEventArgs e)
        {
            Title =  "WIX3xDemo Core WPF app :" + e.GetPosition(this).ToString();
        }

        private void Add_Click(object sender, RoutedEventArgs e)
        {

        }
        private void Refresh_Click(object sender, RoutedEventArgs e)
        {

        }

        private void CommentsList_Loaded(object sender, RoutedEventArgs e)
        {
        
        }
    }
}
