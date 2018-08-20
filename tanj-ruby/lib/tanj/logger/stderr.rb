module Tanj
  module Logger
    class Stderr < BaseLogger
      def log(line)
        $stderr.puts line
      end
    end
  end
end
