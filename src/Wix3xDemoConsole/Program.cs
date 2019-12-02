using System;
using Wix3xDemoLib;

namespace Wix3xDemoConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                Console.WriteLine("WIX3xDemo Core WPF app\n");
                CommentsData data = new CommentsData();
                if (args.Length > 0)
                {
                    foreach (string item in args)
                    {
                        if (item.Contains("--list"))
                        {
                            foreach (string comment in data.GetAllComments())
                            {
                                Console.WriteLine(comment);
                            }
                        }
                        else if (item.Contains("--add"))
                        {
                            if (args[2] != null)
                            {
                                data.Add(args[2]);
                            }
                        }
                        else
                        {
                            Console.WriteLine("Usage:");
                            Console.WriteLine("Wix3xDemoConsole.exe [options]");
                            Console.WriteLine("--help\t\t To get the help");
                            Console.WriteLine("--list\t\t To get all the comments from DB");
                            Console.WriteLine("--add 'comments'\t To add a given comment to DB ");
                        }
                    }
                }
                else
                {
                    Console.WriteLine("Usage:");
                    Console.WriteLine("Wix3xDemoConsole.exe [options]");
                    Console.WriteLine("--help\t\t To get the help");
                    Console.WriteLine("--list\t\t To get all the comments from DB");
                    Console.WriteLine("--add 'comments'\t To add a given comment to DB ");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }           
            
        }
    }
}
