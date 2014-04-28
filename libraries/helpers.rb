module PHPBox
  module Helpers

    def setup_apache_site(app, app_dir)
      if app.attribute?('hostnames')
        host_names = app['hostnames']
      elsif app.attribute?('hostname')
        host_names = [app['hostname']]
      else
        host_names = ['localhost']
      end
      web_app app['appname'] do
        server_name host_names[0]
        server_aliases host_names
        docroot ::File.join(app_dir, 'public')
      end
    end

    def setup_nginx_site(app, app_dir)
      config = merge_nginx_config(
        node["cookbook_phpbox"]["default_config"]["nginx"],
        app["nginx_config"]
      )

      htpasswd_username = node['cookbook_phpbox']['htpasswd']['username']
      htpasswd_password = node['cookbook_phpbox']['htpasswd']['password']
      htpasswd_path = node['cookbook_phpbox']['htpasswd']['path']
      if htpasswd_username != '' || htpasswd_password != ''
        htpasswd_path = ''
      end

      template( File.join(node["nginx"]["dir"], "sites-available", app["appname"]) ) do
        source    config["template_name"]
        cookbook  config["template_cookbook"]
        mode      "0644"
        owner     "root"
        group     "root"
        variables(
          :root_path      => ::File.join(app_dir, 'public'),
          :log_dir        => node["nginx"]["log_dir"],
          :appname        => app["appname"],
          :hostname       => app["hostname"],
          :upstream       => app["upstream_name"] ? app["upstream_name"] : 'backend',
          :listen_port    => config["listen_port"],
          :ssl_key        => config["ssl_key"],
          :ssl_cert       => config["ssl_cert"],
          :htpasswd_path  => htpasswd_path
        )
        notifies :reload, "service[nginx]"
      end

      # TODO issue: nginx not reload enabled site
      nginx_site app["appname"] do
        notifies :reload, "service[nginx]"
      end
    end

    def merge_nginx_config(default_config, app_config)
      config = default_config.to_hash
      config.merge(app_config || {})
    end

  end



end
