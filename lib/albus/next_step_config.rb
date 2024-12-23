module Albus
  class NextStepConfig
    attr_reader :step_name
    attr_reader :step_class

    def initialize(step_name:, step_class:, lock_current:, lock_all_previous:)
      @step_name = step_name.to_sym
      @step_class = step_class
      @lock_current = !!lock_current
      @lock_all_previous = !!lock_all_previous
    end

    def lock_current?
      @lock_current
    end

    def lock_all_previous?
      @lock_all_previous
    end
  end
end
