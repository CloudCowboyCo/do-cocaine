#Droplet Deploy
def deploy_droplet(config, token)
  client = DropletKit::Client.new(access_token: token)
  droplet = DropletKit::Droplet.new(name: config[:name], region: config[:region], size: config[:size], image: config[:image], user_data: config[:user_data], ssh_keys: config[:ssh_keys].to_s.split, private_networking: config[:private_networking])

  create = client.droplets.create(droplet)
  while client.droplets.find(id: create.id.to_s).status != 'active' do print "." end
  sleep(25)
  # This return might want to return creation ID.
  # returning of the ID would allow for further operations on this node.
  # while the next area can still obtain IP.
  return do_ip_info(client.droplets.find(id: create.id.to_s))
end
