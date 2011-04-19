require 'rubygems'
require 'activerecord'
require 'erb'
require 'yaml'
#ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.colorize_logging = false
#dbconfig = YAML::load(ERB.new(IO.read(File.open('includes/database.yml'))).result)
dbconfig = YAML::load(ERB.new(File.open('includes/database.yml').read).result)
ActiveRecord::Base.establish_connection(dbconfig["development"])

#some global variables here:(should have been stored in db but meh...)
$reroute_insertion_space_num  = 100 #how many passengers the buses are allowed to pickup during each routine segment
$distance_justification_num = 0.0009 #determines how close the passengers has to be around the bus routine to be pickup dynamically
$minLocationNum = 8 #only start the distribution when incoming locations are more than this number
$maxLocationNum = 18 #stop the distribution and report a service full message since the system can not handle this many quests at a time, default is 18 and good luck with anything more than that
$sim_bus_speed = 0.0018 #latlng point per second
$skip_map_quest_distance = 0.002 #any two points less then this should not be route using map quest
$reqHelpNum = 1 #if bus has a passenger queue more than this number, than this bus will be requesting help from idle buses.
