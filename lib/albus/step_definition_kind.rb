class StepDefinitionKind < Anchormodel
  attr_reader :step_definition_class
  attr_reader :wizard_module

  # Step definitions automatically register themselves here.

  def next_step_kinds
    @next_step_kinds.map { |step_kind_name| self.class.find(step_kind_name) }
  end

  def self.for_wizard(wizard_name)
    all.select { |am| am.key.start_with?("#{wizard_name.to_s.underscore}__") }
  end
end
