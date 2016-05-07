require 'droplet_kit'
require 'pry'
#
##
##
##
##
##
##
# hand it a DigitalOcean system and it hands back public IP and private IP

def do_ip_info(systemID)
## This name is ambiguous
## An IP could be requested for nodes that are freshly created and already iniated instances
    #be a request for freshly created droplets.

## The 
    # parameter system ID 
    # returns IP address of not
    binding.pry
	if systemID.networks.v4[0].type == 'private'
    # this was someone else's solution.
    # There might be a way to do this easier / cleaner
	  ip_private = systemID.networks.v4[0].ip_address
	  ip_public = systemID.networks.v4[1].ip_address
	else
	  ip_private = systemID.networks.v4[1].ip_address
	  ip_public = systemID.networks.v4[0].ip_address
	end
	return ip_public, ip_private
end

# validation of parameters:
# name validation - generate if needed
# region validation - SF1 default 
# size validation - default if none
# image validatoin - default to ubuntu if none - we might be able to poll DO for this
# ssh_key validation - default to none
# priavate_networking - default to false
# validate a configuration before you shipping it to DO
# Testing userdata isn't an option as a blank userdata is accetable
def do_config_validation(config)
    if config[:name] == 'default' 
        config[:name] = Time.now.to_s.split.join.delete!"-:"
    end

    if config[:region] == nil 
        config[:region] = "nyc3" 
        p "region wasn't set"
    end
    if config[:size] == nil  
        config[:size] = '1gb' 
        p "size wasn't set" 
    end
    if config[:image] == nil 
        config[:image] = "ubuntu-14-04-x64" 
        p "image wasn't set" 
    end
    if config[:ssh_key].to_s.split == nil 
        config[:ssh_key] = ['111111'] 
        p "ssh_keys not provided" 
    end
    if config[:private_networking] == nil 
        config[:private_networking] = false 
        p "pirvate networking false" 
        p config[:private_networking]
    end
    return config
end


def do_ssh_key_list(token)
    if token == ""
        p "Token not provided"
    end
    # This should query DO for a list of the ssh keys and IDs.
    session = DropletKit::Client.new(access_token: token)
    keys = Hash.new
    session.ssh_keys.all.each { |x| keys[x[:name].to_s] = x[:id] }
    return keys
end
def do_region_droplet_list(token)
    session = DropletKit::Client.new(access_token: token)
    region = Hash.new
    #binding.pry
    #:@slug=>"sfo1", 
    #:@name=>"San Francisco 1", 
    #:@sizes=>["32gb", "16gb", "2gb", "1gb", "4gb", "8gb", "512mb", "64gb", "48gb"], 
    #:@available=>true, 
    #:@features=>["private_networking", "backups", "ipv6", "metadata"]}>,
end

def do_region_list(token)
    session = DropletKit::Client.new(access_token: token)
    regions = Hash.new
    session.regions.all.each { |x| regions[x[:name]] = x[:slug]}
    binding.pry
    return regions
end

def do_account(token)
    session = DropletKit::Client.new(access_token: token)
    account = Hash.new
    session.account.info[:droplet_limit]
    session.account.info[:floating_ip_limit]
    session.account.info[:email]
    session.account.info[:uuid]
    session.account.info[:email_verified]
end

def do_droplet_list(token)
    session = DropletKit::Client.new(access_token: token)
    droplets = Hash.new
    session.droplets.all.each { |x| droplets[x[:id]] = x[:name] }
    # droplets :id => :name 
    return droplets
end

def do_droplet_ip(token, dropletID)
    session = DropletKit::Client.new(access_token: token)
    session.droplets.all.each { |x| 
        if x[:id] = dropletID
            do_ip_info(x[:id].to_s) 
        end}
    return
end


###
###
#DropletKit Droplet Helpers
###
###
###

#create a new droplet

#create multiple droplets

#list all droplets

#Listing Droplets by Tag

#list all droplets

#list all availble kernels for a droplet
#list actions for a droplet
#delete a droplet
#delete a dorplet by tag
#List neighbors for a droplet
#list all droplet neighbors


#Goal Pull IP for puppet master:
#Set DNS for a node 

def command(cmd)
    case cmd
    when "backup"
        puts "backup"
    when "test"
        puts "test"
    when "snapshot"
        puts "snapshot"
    else "command not found"
    end
end

#binding.pry
do_droplet_ip(token, 3258354)
puts do_droplet_ip(token)
