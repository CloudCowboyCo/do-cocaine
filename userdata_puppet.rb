def userdata_puppet(system_name)
return <<-EOM
#!/bin/bash
cd ~
ntpdate pool.ntp.org
apt-get update 
apt-get -y install ntp

# add ntp pools to your configuration file
echo "server 0.us.pool.ntp.org" > ntptemp.text
echo "server 1.us.pool.ntp.org" >> ntptemp.text
echo "server 2.us.pool.ntp.org" >> ntptemp.text
echo "server 3.us.pool.ntp.org" >> ntptemp.text
cat /etc/ntp.conf >> ntptemp.text 
cat ntptemp.text > /etc/ntp.conf
	
service ntp restart
# download puppetlabs release
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
# install the package
dpkg -i puppetlabs-release-trusty.deb
# update apt
apt-get update
# install puppetmaster
apt-get -y install puppetmaster-passenger
# stop apahce to allow for configuration changes
service apache2 stop
# configure apt to not go beyond current version of puppet
puppet_version=`puppet help | tail -n 1 | grep Puppet | awk '/Puppet/' | awk '{print $2;}'`
puppet_version="${puppet_version%?}*"
echo "Package: puppet puppet-common puppetmaster-passenger" > /etc/apt/preferences.d/00-puppet.pref
echo "Pin: version $puppet_version" >> /etc/apt/preferences.d/00-puppet.pref
echo "Pin-Priority: 501" >> /etc/apt/preferences.d/00-puppet.pref

# set up certs for puppet
# delete current certs
rm -rf /var/lib/puppet/ssl

echo """
[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/var/run/puppet
factpath=$vardir/lib/facter
certname = #{system_name}
dns_alt_names = puppet,puppet.nyc2.example.com,#{system_name}

[master]
# These are needed when the puppetmaster is run by passenger
# and can safely be removed if webrick is used.
ssl_client_header = SSL_CLIENT_S_DN
ssl_client_verify_header = SSL_CLIENT_VERIFY
""" > /etc/puppet/puppet.conf
puppet master --verbose --no-daemonize
service apache2 start
EOM
end
