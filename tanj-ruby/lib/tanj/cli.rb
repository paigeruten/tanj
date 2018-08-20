module Tanj
  class CLI
    def run(args)
      frontend = Tanj::Frontend.new
      while line = gets
        frontend.receive(line)
      end
    end
  end
end
