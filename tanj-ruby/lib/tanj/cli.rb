module Tanj
  class CLI
    def run(args)
      frontend = Tanj::Frontend.new(step: args.first == "step")
      args.shift if args.first == "step"
      if args.empty?
        f = $stdin
      else
        f = File.open(args.first, "r")
      end

      while line = gets
        frontend.receive(line)
      end
      frontend.no_more!

      f.close if !args.empty?
    end
  end
end
