#
# Cookbook Name:: cookbook_phpbox
# Recipe:: users
#

# Append www-data to the apps group too.
group node['appbox']['apps_user'] do
  members 'www-data'
  append true
end