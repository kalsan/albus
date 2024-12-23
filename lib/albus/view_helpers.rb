module Albus
  module ViewHelpers
    def edit_step_link(astep, *, params: {}, **, &)
      fail("edit_step_link takes a Astep instance, but #{astep.inspect} was given") unless astep.is_a?(Astep)
      compony_link(astep.step_definition_class, *, standalone_name: :edit, params: { id: astep.id }.merge(params), **, &)
    end

    #===---
    # Used in form to display the buttons:
    #===---

    # Causes submit and saving without validation
    # Use case: step is not completed
    def save_draft_form_button(*, label: I18n.t('albus.save_draft'), **, &)
      Compony.button_component_class.new(label:, type: :submit, value: :save_draft).render(helpers.controller)
    end

    # Causes submit, validation and saving, then creates the next step from the given step name
    # Use case: step is not completed
    def next_to_new_step_form_button(next_step_config, *, **, &)
      next_step_comp = next_step_config.step_class.new
      Compony.button_component_class.new(label: next_step_comp.label, type: :submit, value: "next::#{next_step_config.step_name}").render(helpers.controller)
    end

    # Causes submit, validation and saving, then redirects to the path configured in the final_step configuration
    # Use case: step is not completed and the according step definition has final_step configured
    def finalize_form_button(*, label: I18n.t('albus.finalize'), **, &)
      Compony.button_component_class.new(label:, type: :submit, value: :finalize).render(helpers.controller)
    end

    # Causes submit, validation and saving
    # Use case: step is completed but not locked
    def save_form_button(*, label: I18n.t('albus.save'), **, &)
      Compony.button_component_class.new(label:, type: :submit, value: :save).render(helpers.controller)
    end

    # Causes submit, validation, saving and redirection to the next existing step
    # Use case: step is completed but not locked
    def next_step_form_button(*, label: I18n.t('albus.next_step'), **, &)
      Compony.button_component_class.new(label:, type: :submit, value: :next_step).render(helpers.controller)
    end

    # Causes submit, validation, saving and redirection to the previous existing step
    # Use case: step is completed but not locked
    def previous_step_form_button(*, label: I18n.t('albus.previous_step'), **, &)
      Compony.button_component_class.new(label:, type: :submit, value: :previous_step).render(helpers.controller)
    end
  end
end
