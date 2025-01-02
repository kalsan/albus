module Albus
  class StepDefinition < Compony::Components::WithForm
    include Compony::ComponentMixins::Resourceful

    include StepDefinitionMixins::SetupCommon # This runs a setup block initializing common behavior
    include StepDefinitionMixins::SetupEdit # This runs a setup block initializing the `Edit` component behavior.
    include StepDefinitionMixins::SetupNew # This provides `setup_new` that, if initial_step, runs the setup block initializing the `New` component behavior.

    attr_reader :fields
    attr_reader :model_block
    attr_reader :next_step_configs
    attr_reader :step_definition_kind
    attr_reader :initial_step_block
    attr_reader :initial_step_params
    attr_reader :final_step_params
    attr_reader :fields_to_propagate
    attr_reader :astep

    # Internal
    def self.step_definition_kind_key
      name.split('::')[-2..].map(&:underscore).join('__').to_sym
    end

    def initialize(...)
      @fields = {}
      @next_step_configs = {}

      # Call setup etc.
      super

      register_step_definition_kind! # Register self to StepDefinitionKind
      data_class StepDataFactory.build_data_class_for(self) # Prepare anonymous step datum (virtual data class)
      form_comp_class FormComponentFactory.build_form_class_for(self, custom_form_fields_block: @custom_form_fields_block) # Prepare anonymous form class
    end

    # @override
    def submit_verb(_ = nil)
      @submit_verb
    end

    # DSL method
    # Use this to set the cancancan subject, e.g. the model class of record (must provide this key)
    def cancancan_subject(subject = nil)
      @cancancan_subject ||= subject
    end

    # DSL method
    # Sets a block that will be run in the context of the step data model at the end of its definition.
    # Use this to add validations etc.
    def model(&model_block)
      @model_block = model_block
    end

    # DSL method
    # Sets the layout this component will be rendered with
    def layout(layout)
      @layout = layout.to_sym
    end

    # DSL method
    # Adds a field to the step data model. This also creates an attribute, behaving similarly to a model column.
    # The field will automatically be displayed in the form and the schema will auto-adjust as well.
    def field(name, compony_type, rails_type: compony_type)
      name = name.to_sym
      rails_type = rails_type.to_sym
      compony_type = compony_type.to_sym
      @fields[name] = Compony::MethodAccessibleHash.new(name:, compony_type:, rails_type:)
    end

    # DSL method
    # Enables the "New" component behavior for this step, adding a route to create a fresh Astep.
    # @arg required_params [Array] An array of symbols listing all parameters that are required from the user to initialize the new step with
    # @arg block [Proc] A block that initializes @record, `params` is available inside the block
    def initial_step(required_params: [], &block)
      # Enable initial step internals
      @initial_step = true
      @initial_step_params = required_params
      @initial_step_block = block

      install_setup_new(required_params)
    end

    # DSL method
    # This takes the name of the next step and links this step to that. Buttons will automatically be generated,
    # allowing the user to proceed to any next step if the data is valid.
    # Pressing such a button will mark this step as complete.
    def next_step(next_step_name, lock_current: false, lock_all_previous: false)
      @next_step_configs[next_step_name.to_sym] = NextStepConfig.new(
        step_name:         next_step_name,
        step_class:        self.class.module_parent.const_get(next_step_name.to_s.camelize),
        lock_current:,
        lock_all_previous:
      )
    end

    # DSL method
    # This makes this step "final", allowing a user to submit and terminate the entire journey through the wizard.
    def final_step(redirect_path:, &finalization_block)
      @final_step_config = FinalStepConfig.new(redirect_path_block: redirect_path, finalization_block:)
    end

    # DSL method
    # This defines all fields that should be propagated to the record
    def propagate(*fields_to_propagate)
      @fields_to_propagate = fields_to_propagate.map(&:to_sym)
    end

    # DSL method
    def on_submitted(&block)
      @on_submitted_block = block
    end

    # DSL method
    def on_submitted_respond(&block)
      @on_submitted_respond_block = block
    end

    # DSL method
    def on_submission_failed(&block)
      @on_submission_failed_block = block
    end

    # DSL method
    # This completes this steps, creates the next one and redirects to it.
    # Note: This assumes that validation has already been performed in the standalone blocks.
    def complete_step!(next_step: nil)
      # Make sure the step was validated properly
      unless @astep.valid?
        fail("#{@astep} should have been validated by the standalone blocks, but wasn't.")
      end

      if next_step.nil?
        next_astep = nil
      else
        # Find the class of the next step
        next_step = next_step.to_sym
        next_step_config = next_step_configs[next_step]
        next_step_comp_class = next_step_config.step_class
        if next_step_comp_class.nil?
          fail("#{target.inspect} is not a valid next step for #{inspect}.")
        end
        # Create the next step
        next_astep = Astep.new(
          step_definition_kind: StepDefinitionKind.find(next_step_comp_class.step_definition_kind_key),
          record:               @astep.record,
          index:                @astep.index + 1,
          completed:            false,
          locked:               false,
          data:                 {}
        )
        unless next_astep.save
          fail("Could not save blank next step: #{next_astep.errors.full_messages}")
        end

        @astep.update!(next_step: next_astep, completed: true, locked: next_step_config.lock_current?)
        if next_step_config.lock_all_previous?
          record.asteps.where.not(id: next_astep.id).update_all(locked: true)
        end
      end

      # Propagate
      record.update!(**@astep.data.slice(*@fields_to_propagate.map(&:to_s))) if @fields_to_propagate&.any?

      return next_astep
    end

    def initial_step?
      !!@initial_step
    end

    def final_step?
      !!@final_step_config
    end

    def record
      @astep.record
    end

    # DSL method, overwrites the visible form fields within the form comp
    def form_fields(&block)
      @custom_form_fields_block = block
    end

    protected

    # Checks the Anchormodel for a matching StepDefinitionKind constant for this step definition.
    # Creates it if it doesn't exist yet.
    def register_step_definition_kind!
      @step_definition_kind = StepDefinitionKind.entries_hash[self.class.step_definition_kind_key]
      @register_step_definition_kind ||= StepDefinitionKind.new(
        self.class.step_definition_kind_key,
        step_definition_class: self.class,
        wizard_module:         self.class.module_parent,
        next_step_kinds:       @next_step_configs.values.map(&:step_class).map(&:step_definition_kind_key)
      )
    end
  end
end
