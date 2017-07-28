name             'cookbook_phpbox'
maintainer       'Fred Thompson'
maintainer_email 'fred.thompson@buildempire.co.uk'
license          'Apache 2.0'
description      'PHP and Nginx/Apache server, ready for Capistrano deployment.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.6.10'

recipe 'cookbook_phpbox', 'PHP and Nginx/Apache server, ready for Capistrano deployment.'

%w{ ubuntu }.each do |os|
  supports os
end

%w{apache2 appbox build-essential cookbook_databox htpasswd nginx php php-fpm ssmtp logrotate}.each do |cb|
  depends cb
end
