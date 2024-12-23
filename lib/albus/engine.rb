module Albus
  class Engine < Rails::Engine
    initializer 'albus.controller_mixin' do
      ActiveSupport.on_load :action_controller_base do
        include Albus::ControllerMixin
      end
    end
  end
end
