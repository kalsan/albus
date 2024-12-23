module Albus
  class FinalStepConfig
    attr_reader :redirect_path_block
    attr_reader :finalization_block

    def initialize(redirect_path_block:, finalization_block:)
      fail('redirect_path given to final_step must be callable and return a path.') unless redirect_path_block.respond_to?(:call)
      fail('final_step must be called with a block that finalizes the record.') unless redirect_path_block.respond_to?(:call)

      @redirect_path_block = redirect_path_block
      @finalization_block = finalization_block
    end
  end
end
