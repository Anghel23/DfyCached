using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Diagnostics;

class Program
{
    static void Main()
    {
        TcpListener server = null;
        try
        {
            int port = 12345;
            server = new TcpListener(IPAddress.Any, port);
            server.Start();
            Console.WriteLine($"Server pornit pe portul {port}. Aștept conexiuni...");

            while (true)
            {
                TcpClient client = server.AcceptTcpClient();
                Console.WriteLine("Client conectat!");
                ThreadPool.QueueUserWorkItem(HandleClient, client);
            }
        }
        finally
        {
            server?.Stop();
        }
    }

    static void HandleClient(object clientObj)
    {
        TcpClient client = (TcpClient)clientObj;
        NetworkStream stream = client.GetStream();

        byte[] buffer = new byte[1024];
        int bytesRead;
        StringBuilder data = new StringBuilder();

        try
        {
            while ((bytesRead = stream.Read(buffer, 0, buffer.Length)) != 0)
            {
                string received = Encoding.UTF8.GetString(buffer, 0, bytesRead);
                data.Append(received);

                int newlineIndex;
                while ((newlineIndex = data.ToString().IndexOf('\n')) >= 0)
                {
                    string command = data.ToString(0, newlineIndex).Trim();
                    Console.WriteLine($"Comanda primita: {command}");
                    data.Remove(0, newlineIndex + 1);

                    string response = ExecuteDafnyScript(command);
                    
                    Console.WriteLine($"Raspuns trimis: {response}");
                    byte[] responseBytes = Encoding.UTF8.GetBytes(response + "\n");
                    stream.Write(responseBytes, 0, responseBytes.Length);
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Eroare: {ex.Message}");
        }
        finally
        {
            client.Close();
            Console.WriteLine("Client deconectat.");
        }
    }

    static string ExecuteDafnyScript(string command)
    {
        try
        {
            ProcessStartInfo startInfo = new ProcessStartInfo
            {
                FileName = "../../Dfy-Side/DfyCached.exe",
                Arguments = $"\"{command}\"",
                RedirectStandardOutput = true,
                UseShellExecute = false,
                CreateNoWindow = true
            };

            using (Process process = Process.Start(startInfo))
            {
                string result = process.StandardOutput.ReadToEnd();
                process.WaitForExit();
                return result;
            }
        }
        catch (Exception ex)
        {
            return $"Eroare la executarea scriptului Dafny: {ex.Message}";
        }
    }
}
