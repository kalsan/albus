module Albus
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root Albus::Engine.root

      def copy_migrations
        timestamp = (DateTime.now.strftime '%Y%m%d%H%M%S')
        if Rails.root.glob('db/migrate/*create_albus_asteps.rb/*create_albus_asteps.rb/migrate/*create_albus_asteps.rb/*create_albus_asteps.rb').any?
          Rails.logger.debug '[exist] create_albus_asteps.rb'
        else
          copy_file 'db/migrate/create_albus_asteps.rb', "db/migrate/#{timestamp}_create_albus_asteps.rb"
        end
      end
    end
  end
end
