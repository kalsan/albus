module Albus
  # Include this in app/models/astep.rb
  module AstepMixin
    extend ActiveSupport::Concern

    included do
      belongs_to_anchormodel :step_definition_kind, model_methods: false

      belongs_to :record, polymorphic: true
      belongs_to :next_step, class_name: 'Astep', optional: true, inverse_of: :previous_step
      has_one :previous_step, class_name: 'Astep', foreign_key: 'next_step_id', inverse_of: :next_step, dependent: :nullify

      accepts_nested_attributes_for :record

      validates :next_step_id, uniqueness: true, allow_nil: true # make sure has_one will remain has_one

      delegate :step_definition_class, to: :step_definition_kind
    end
  end
end
