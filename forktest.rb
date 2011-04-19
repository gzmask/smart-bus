puts "before fork pid:" + Process.pid.to_s
puts "before fork gid:" + Process.gid.to_s
Process.fork do
	puts "in fork pid:" + Process.pid.to_s
	puts "in fork gid:" + Process.gid.to_s
	system('SmartBusWeb/script/server')
end

puts "after fork pid:" + Process.pid.to_s
puts "after fork gid:" + Process.gid.to_s
system('ruby smart_bus_server.rb')
