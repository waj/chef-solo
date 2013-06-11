%w(/ /shared /releases).each do |dir|
  directory "/u/apps/resource_map#{dir}" do
    owner "root"
    group "waj"
    mode 00775
    action :create
    recursive true
  end
end

include_recipe "database::mysql"
include_recipe "passenger_apache2"
package "mercurial"

mysql_database "resource_map" do
  connection host: "localhost", username: "root", password: node["mysql"]["server_root_password"]
  action :create
end

template "/u/apps/resource_map/shared/database.yml" do
  source "database.yml.erb"
  owner "root"
  group "waj"
  mode 0640
end

template "/u/apps/resource_map/shared/settings.yml" do
  source "resource_map_settings.yml.erb"
  owner "root"
  group "waj"
  mode 0640
end

web_app "resource_map" do
  server_name node['server_name']
  docroot "/u/apps/resource_map/current/public"
end
