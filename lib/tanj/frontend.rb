module Tanj
  class Frontend
    def initialize
      @events = []
    end

    def receive(line)
      # assume line starts with "tanj| "
      event = JSON.parse(line[6..-1], symbolize_names: true)
      @events.push event
      if event[:type] == 'array'
        ary = event[:value]
        if ary.empty?
          puts Paint['<empty array>', 'dark gray']
        else
          print Paint["#{event[:name]}", :underline, :bright, :blue], ': '
          ary.each.with_index do |val, idx|
            cell_color = nil
            event[:options][:highlight].each do |color, target_idx|
              if target_idx.is_a?(String) && target_idx['..']
                target_idx = Range.new(*target_idx.split('..').map(&:to_i))
              end
              if target_idx === idx && (cell_color.nil? || target_idx.is_a?(Integer))
                cell_color = color.to_s
              end
            end
            print Paint['[ ', cell_color || 'dark gray']
            print Paint[val.inspect, :bright, cell_color || 'gray']
            print Paint[' ] ', cell_color || 'dark gray']
          end
          puts
        end
      elsif event[:type] == 'message'
        puts Paint[event[:message], :bright, :yellow]
      elsif event[:type] == 'variable'
        print Paint["#{event[:name]}", :underline, :bright, :blue], ': '
        puts Paint[event[:value].inspect, :bright, :white]
      else
        p event
      end
    end
  end
end
