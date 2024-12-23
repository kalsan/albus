module Albus
  module StepDefinitionMixins
    module SetupCommon
      extend ActiveSupport::Concern

      included do
        setup do
          assign_attributes do
            # Validate params against the form's schema
            local_form_comp = form_comp # Capture form_comp for usage in the Schemacop call
            local_data = @data # Capture data for usage in the Schemacop call
            local_controller = controller
            schema = Schemacop::Schema3.new :hash, additional_properties: true do
              any_of? :id do # depends on and is inforced by the applicable route
                str
                int cast_str: true
              end
              hsh? local_form_comp.schema_wrapper_key_for(local_data), &local_form_comp.schema_block_for(local_data, local_controller)
            end
            validated_params = schema.validate!(controller.request.params)
            attrs_to_assign = validated_params[form_comp.schema_wrapper_key_for(@data)]
            @data.assign_attributes(attrs_to_assign) if attrs_to_assign
          end

          submit_path do |controller|
            if @submit_verb == :post
              Compony.path(comp_name, family_name, standalone_name: :new)
            elsif @submit_verb == :patch
              Compony.path(comp_name, family_name, standalone_name: :edit, id: controller.params[:id])
            else
              fail("Unknown @submit_verb #{@submit_verb.inspect}")
            end
          end

          #==--
          # Common respond blocks
          #==--

          on_submission_failed do
            Rails.logger.warn(@data&.errors&.full_messages)
            render_standalone(controller, status: :unprocessable_entity, standalone_name: @standalone_name)
          end

          # Behavior to run when the submission has been successful
          on_submitted_respond do
            flash.notice = I18n.t('albus.data_was_submitted')
            # Find out which next step to take
            instruction, target = params[:button].presence&.split('::')
            case instruction
            when 'next'
              # This completes this steps, creates the next one and redirects to it.
              # Validation has already been performed in the standalone blocks.
              next_astep = complete_step!(next_step: target.to_sym)
              controller.redirect_to(Albus.edit_step_path(next_astep))
            when 'save_draft', 'save'
              # save_draft: This skips validation and does not complete the step.
              # save: This updates an already completed step. Validation has already been performed.
              controller.redirect_to(Albus.edit_step_path(@astep))
            when 'previous_step'
              # This updates an already completed step and redirects the existing previous step. Validation has already been performed.
              controller.redirect_to(Albus.edit_step_path(@astep.previous_step))
            when 'next_step'
              # This updates an already completed step and redirects the existing next step. Validation has already been performed.
              controller.redirect_to(Albus.edit_step_path(@astep.next_step))
            when 'finalize'
              # This finishes the journey through the wizard
              fail("Called finalize on a step #{self.class.inspect} that is not a final step.") unless final_step?
              complete_step!
              record.asteps.update_all(completed: true, locked: true)
              @final_step_config.finalization_block.call(record)
              controller.redirect_to instance_exec(&@final_step_config.redirect_path_block)
            else
              fail("Next instruction #{instruction.inspect} is invalid.")
            end
          end

          form_cancancan_action nil # Per-field authorization for steps is currently not supported. Would have to authorize columns on anonymous class.

          #==--
          # Content blocks
          #==--

          # Main
          content do
            content :before_form
            concat form_comp.render(controller, data: @data)
            content :after_form
          end

          content :label, before: :main do
            h1 component.label
          end

          content :breadcrumb, before: :main do
            if @astep
              record.asteps.order(index: :asc).each do |step|
                if @astep.id == step.id
                  div component.label
                else
                  div edit_step_link(step)
                end
              end
            else
              div component.label
            end
          end
        end
      end
    end
  end
end
