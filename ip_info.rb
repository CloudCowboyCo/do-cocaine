def ip_info(created_server)
	if created_server.networks.v4[0].type == 'private'
	  ip_private = created_server.networks.v4[0].ip_address
	  ip_public = created_server.networks.v4[1].ip_address
	else
	  ip_private = created_server.networks.v4[1].ip_address
	  ip_public = created_server.networks.v4[0].ip_address
	end
	return ip_public, ip_private
end