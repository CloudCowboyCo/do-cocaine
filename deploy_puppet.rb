
require './droplet_deploy.rb'# Calls droplet
require 'droplet_kit' # Loads DigitalOcean's gem 
require './ip_info.rb' 
require './userdata_puppet.rb'
require 'pry'
require 'yaml'

# Initialize configuration variables
cnf = YAML::load_file(File.join(__dir__, 'config.yml'))
config=cnf[:droplet]
token=cnf[:admin][:token]
# Date stampe the name if no droplet name provided
if config[:name] == "default"
    config[:name] = Time.now.to_s.split.join.delete!"-:" # TODO Add ability to group with prefix
end
# set user_date with proper hostname 
config["user_data"] = userdata_puppet(config[:name].to_s)

ip_public = deploy_droplet(config, token)
p ""
p 'To access your system use:'
p ip_public[0] 

