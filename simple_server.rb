require 'socket'
require 'json'

server = TCPServer.open(2000)

loop {
	client = server.accept
	request = client.read_nonblock(256)
	header, body = request.split("\r\n\r\n", 2)
	method = header.split[0]
	path = header.split[1][1..-1]

	if File.exist?(path)
		data = File.read(path)
		client.print "HTTP/1.0 200 OK\r\nDate: #{Time.now.ctime}\r\ntext/html\r\nContent-Length: #{File.size(path)}\r\n\r\n"
		
		if method == "GET"
			client.puts data
		elsif method == "POST"
			params = JSON.parse(body)
			form_data = "<li>Name: #{params['person']['name']}</li><li>E-mail: #{params['person']['email']}</li>" 
			client.puts data.gsub('<%= yield %>', form_data)
		end

	else
		client.puts "HTTP/1.0 404 Not Found"
	end
	client.close	
}
