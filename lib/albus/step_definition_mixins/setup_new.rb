module Albus
  module StepDefinitionMixins
    # Enable the "New" variant: creating a new step model and record
    module SetupNew
      protected

      # This gets called from within a setup block when `initial_step` is called.
      def install_setup_new(required_params)
        # Data loader for new (used below)
        new_load_data_block = proc do
          # Initialize the virtual data class
          @data = data_class.new
          # Validate required params
          required_params.each { |param_name| params.require(param_name) }
          # Run the initial_step block which will initialize the record
          instance_exec(&component.initial_step_block)
        end

        standalone :new, path: [family_name, comp_name].join('/') do
          layout @layout if @layout.present?
          verb :get do
            authorize { can?(:new, @cancancan_subject || fail("You must call `cancancan_subject` in #{component.class}.")) }
            load_data do
              @submit_verb = :post
              @standalone_name = :new
              evaluate_with_backfire(&new_load_data_block)
            end
            assign_attributes # enables block defined below
            respond do
              render_standalone(controller, standalone_name: :new)
            end
          end
          verb :post do
            authorize { can?(:create, @cancancan_subject || fail("You must call `cancancan_subject` in #{component.class}.")) }
            load_data do # This override allows for dynamic submit verb generation.
              @submit_verb = :post
              @standalone_name = :new
              evaluate_with_backfire(&new_load_data_block)
            end
            assign_attributes # enables block defined below
            store_data do
              if params[:button] == 'save_draft' || @data.validate # Skip validation if we're just saving a draft
                @astep = Astep.new(
                  step_definition_kind: @step_definition_kind,
                  record:               @record, # This was set in the initial_step_block
                  index:                0,
                  completed:            false,
                  locked:               false,
                  data:                 @data
                )
                unless @astep.save
                  fail("Could not save step: #{@astep.errors.full_messages}")
                end
                @submission_succeeded = true
              end
            end
            respond do
              if @submission_succeeded
                evaluate_with_backfire(&@on_submitted_block) if @on_submitted_block
                evaluate_with_backfire(&@on_submitted_respond_block)
              else
                evaluate_with_backfire(&@on_submission_failed_block)
              end
            end
          end
        end
      end
    end
  end
end
