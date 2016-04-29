## This section needs to move up stream.
#
#
require './droplet_deploy.rb'# Calls droplet
require 'droplet_kit' # Loads DigitalOcean's gem 
require './ip_info.rb' 
require './userdata_puppet.rb'
require 'pry'
require 'yaml'
#
##
##
#

## CLIENT REWRITE
## ## NTH - each config file can have independent home directories. 
def deploy_node(configfile)
    token[:admin][:token] = YAML::load_file(File.join(__dir__, 'configfile')
    config[:droplet] = YAML::load_file(File.join(__dir__, 'configfile')
end


###
# Initialize configuration variables
cnf = YAML::load_file(File.join(__dir__, 'config.yml'))
config=cnf[:droplet]
token=cnf[:admin][:token]
###


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
