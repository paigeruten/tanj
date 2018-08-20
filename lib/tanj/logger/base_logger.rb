module Tanj
  module Logger
    class BaseLogger
      def log(line)
        raise NotImplementedError
      end
    end
  end
end
