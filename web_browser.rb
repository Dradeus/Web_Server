require 'socket'
require 'json'

host = 'localhost'
port = 2000

puts "Would you like to issue a 'GET' or a 'POST'?"
request = gets.chomp.upcase

if request == "GET"
	request = "GET /index.html HTTP/1.0\r\n\r\n"
else
	puts "Viking Raid Registration:"
	puts "Enter name: "
	name = gets.chomp
	puts "Enter e-mail: "
	email = gets.chomp

	params = {:person => {:name => name, :email => email}}.to_json
	request = "POST /thanks.html HTTP/1.0\r\nContent-Length: #{params.length}\r\n\r\n#{params}"
end

socket = TCPSocket.open(host,port)
socket.print(request)
response = socket.read
headers,body = response.split("\r\n\r\n", 2)
print body
socket.close