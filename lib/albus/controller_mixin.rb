module Albus
  module ControllerMixin
    extend ActiveSupport::Concern

    include Albus::ViewHelpers

    included do
      # Declare all methods in each such module as helper_method
      Albus::ViewHelpers.public_instance_methods.each { |helper_method_sym| helper_method helper_method_sym }
    end
  end
end
