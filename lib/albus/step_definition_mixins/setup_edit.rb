module Albus
  module StepDefinitionMixins
    # "Edit" variant: assuming the step model already exists
    module SetupEdit
      extend ActiveSupport::Concern

      included do
        # Data loader for edit (used below)
        edit_load_data_block = proc do
          @astep = Astep.find(params[:id]) || fail(ActiveRecord::RecordNotFound, "Astep #{params[:id]} was not found.")
          unless @astep.step_definition_kind.step_definition_class == component.class
            fail ActiveRecord::RecordNotFound,
                 "Attempted to load Astep with step definition kind #{@astep.step_definition_kind} through class #{component.class}."
          end
          @data = data_class.new(@astep)
        end

        setup do
          standalone :edit, path: [family_name, comp_name, ':id'].join('/') do
            layout @layout if @layout.present?
            verb :get do
              authorize { can?(:edit, @cancancan_subject || fail("You must call `cancancan_subject` in #{component.class}.")) }
              load_data do # This override allows for dynamic submit verb generation.
                @submit_verb = :patch
                @standalone_name = :edit
                evaluate_with_backfire(&edit_load_data_block)
              end
              assign_attributes # enables block defined below
              respond do
                render_standalone(controller, standalone_name: :edit)
              end
            end
            verb :patch do
              authorize { can?(:update, @cancancan_subject || fail("You must call `cancancan_subject` in #{component.class}.")) }
              load_data do # This override allows for dynamic submit verb generation.
                @submit_verb = :patch
                @standalone_name = :edit
                evaluate_with_backfire(&edit_load_data_block)
              end
              assign_attributes # enables block defined below
              store_data do
                fail("Attempt to update locked step #{@astep.inspect}.") if @astep.locked?
                if params[:button] == 'save_draft' || @data.validate # Skip validation if we're just saving a draft
                  @astep.update!(data: @data)
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
end
