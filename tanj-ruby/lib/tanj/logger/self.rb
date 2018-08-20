module Tanj
  module Logger
    class Self < BaseLogger
      def initialize
        @frontend = Tanj::Frontend.new
      end

      def log(line)
        @frontend.receive line
      end
    end
  end
end
