ruby script/generate scaffold WebBus capacity:integer
ruby script/generate scaffold WebLocation web_bus_id:integer latitude:float longitude:float is_current:boolean is_end:boolean is_pickup:boolean is_dropdown:boolean web_passenger_id:integer order_num:integer
ruby script/generate scaffold WebPassenger password:string web_bus_id:integer
ruby script/plugin install svn://rubyforge.org/var/svn/ym4r/Plugins/GM/trunk/ym4r_gm
ruby script/plugin install svn://rubyforge.org/var/svn/ym4r/Plugins/Mapstraction/trunk/ym4r_mapstraction
