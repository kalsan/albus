module Albus
  def self.edit_step_path(astep, *, **, &)
    fail("Albus.edit_step_path takes a Astep instance, but #{astep.inspect} was given") unless astep.is_a?(Astep)
    Compony.path(astep.step_definition_class, astep, *, standalone_name: :edit, **, &)
  end

  def self.new_step_button(*, **, &)
    Compony.button(*, standalone_name: :new, **, &)
  end

  def self.edit_step_button(astep, *, **, &)
    fail("Albus.edit_step_button takes a Astep instance, but #{astep.inspect} was given") unless astep.is_a?(Astep)
    Compony.button(astep.step_definition_class, astep, *, standalone_name: :edit, **, &)
  end
end

require 'anchormodel'
require 'compony'

require 'albus/step_definition_kind'
require 'albus/astep_mixin'
require 'albus/engine'
require 'albus/final_step_config'
require 'albus/next_step_config'
require 'albus/step_definition_mixins/setup_common'
require 'albus/step_definition_mixins/setup_edit'
require 'albus/step_definition_mixins/setup_new'
require 'albus/form_component_factory'
require 'albus/step_definition'
require 'albus/step_data_factory'
require 'albus/version'
require 'albus/view_helpers'
require 'albus/controller_mixin'
