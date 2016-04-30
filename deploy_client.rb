## This section needs to move up stream.
#
#
require './droplet_deploy.rb'# Calls droplet
require 'droplet_kit' # Loads DigitalOcean's gem 
require './do_helpers.rb' 
require './userdata_puppet_client.rb'
require 'yaml'
configFile = 'config.yml'

config = YAML::load_file(File.join(__dir__, configFile))
config = config[:droplet]
config = do_config_validation(config)

