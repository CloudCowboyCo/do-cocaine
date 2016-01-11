require './droplet_deploy.rb'
require 'droplet_kit'
require './ip_info.rb'
require './userdata_puppet.rb'
require 'pry'
require 'yaml'

# Initialize configuration variables
cnf = YAML::load_file(File.join(__dir__, 'config.yml'))
@token=cnf["do_token"]["admin"]
system_name = "puppet"+rand(1000).to_s	
systemInfo = {"name" => system_name, "region" => "nyc3", "size" => "1gb", "image" => "ubuntu-14-04-x64", "user_data" => userdata_puppet(system_name), "ssh_keys" => ['1520383']}

ip_public = deploy_droplet(systemInfo)
puts "Here we go again......"
puts ip_public 