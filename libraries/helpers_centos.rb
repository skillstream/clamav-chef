module ClamavCookbook
  module Helpers
    module Centos
      # The centos7 packages leave something to be desired
      def centos7_post_install
        proper_server_service = '/usr/lib/systemd/system/clamd@server.service'
        broken_server_service = '/usr/lib/systemd/system/clamd@.service'
        file server_service do
          owner 'root'
          group 'root'
          mode 0755
          content ::File.open(broken_server_service).read
          action :create
          not_if { File.exist? server_service }
        end
        file broken_server_service do
          action :delete
        end
      end
    end
  end
end
      
