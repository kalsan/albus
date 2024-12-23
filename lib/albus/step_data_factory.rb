module Albus
  module StepDataFactory
    # Called by StepDefinition components, this returns an anonymous class suitable for
    # holding data for the caller's form.
    def self.build_data_class_for(step_definition)
      return Class.new(ActiveType::Object) do
        def self.model_name
          ActiveModel::Name.new(self, nil, 'anonymous_step_datum')
        end

        include ActiveModel::Attributes
        include Compony::ModelMixin
        include Anchormodel::ModelMixin

        attr_reader :astep

        def initialize(astep = nil, ...)
          @astep = astep
          super(...)
          assign_attributes(@astep.data) if @astep
        end

        step_definition.fields.each do |name, field|
          attribute name, field.rails_type
          field name, field.compony_type
        end

        if step_definition.model_block
          instance_eval(&step_definition.model_block)
        end
      end
    end
  end
end
