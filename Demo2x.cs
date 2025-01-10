using System;
using System.Text;

namespace  MM
{
    public class C
    {
        private static byte[]? buffer;

        public static void init()
        {
            Console.WriteLine("Starting server...");
        }

        public static void put(byte[] buffer)
        {
            C.buffer = buffer;
            Console.WriteLine("Received: " + Encoding.UTF8.GetString(C.buffer));
            Console.Out.Flush();
        }

        public static byte[] get()
        {
            Console.WriteLine("Please enter a message:");
            Console.Out.Flush();
            string input = Console.ReadLine();
            C.buffer = Encoding.UTF8.GetBytes(input);
            return C.buffer;
        }
    }
}
