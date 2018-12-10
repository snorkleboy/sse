require 'socket'
class Server
    def initialize()
        @server = TCPServer.new 2000
        loop do
            Thread.start(@server.accept) do |client|
                handleClient client
            end
        end
    end
    def handleClient(client)
        msg = client.recv(300).split("\n")
        if (msg[0].include?"GET / HTTP")
            handleHTTP(client, msg)
        end
    end

    def handleHTTP(client, headers)
        puts headers
        client.puts "HTTP/1.1 200\r\n" # 1
        client.puts "Content-Type: text/html\r\n" # 2
        client.puts "Access-Control-Allow-Origin: *"
        client.puts "\r\n" # 3
        handleMagicSocket(client)
    end

    def handleMagicSocket(client)
        client.puts "Hello! The time is #{Time.now}.\r\n" #4
        read(client)
        write(client)

    end

    def read(client)
        Thread.new{
            while(line = client.gets)
                puts line
            end
        }
    end

    def write(client)
        puts "\n\n\n type in message to send to client"
        while (true)
            client.puts(gets.chomp)
        end
    end
end


Server.new()