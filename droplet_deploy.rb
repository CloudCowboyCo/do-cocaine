#Droplet Deploy
def deploy_droplet(systemInfo)
  client = DropletKit::Client.new(access_token: @token)
  droplet = DropletKit::Droplet.new(name: systemInfo.fetch("name"), region: systemInfo.fetch("region"), size: systemInfo.fetch("size"), image: systemInfo.fetch("image"), user_data: systemInfo.fetch("user_data"), ssh_keys: systemInfo.fetch("ssh_keys"), private_networking: true)
  create = client.droplets.create(droplet)

  while client.droplets.find(id: create.id.to_s).status != 'active' do print "." end
  sleep(5)
  return ip_info(client.droplets.find(id: create.id.to_s))
end