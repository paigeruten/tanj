module Tanj
  class Frontend
    def initialize
      @events = []
    end

    def receive(line)
      return unless line.start_with? "tanj| "

      event = JSON.parse(line[6..-1], symbolize_names: true)
      @events.push event
      if event[:type] == 'array'
        ary = event[:value]
        if ary.empty?
          puts Paint['<empty array>', 'dark gray']
        else
          print Paint["#{event[:name]}", :underline, :bright, 'deep sky blue'], ': '
          ary.each.with_index do |val, idx|
            idx_layer = 0
            Array(event[:options][:index]).each.sort_by do |target_idx|
              target_idx.is_a?(Array) ? target_idx[1][:value] - target_idx[0][:value] + 2 : 1
            end.each.with_index do |target_idx, target_layer|
              if target_idx.is_a?(Array)
                target_idx = Range.new(*target_idx.map { |v| v[:value] })
              else
                target_idx = target_idx[:value]
              end
              if target_idx === idx
                idx_layer = target_layer + 1
                break
              end
            end
            cell_color = ['white', 'green', 'yellow', 'orange'][idx_layer]
            print Paint['[ ', cell_color]
            print Paint[val.inspect, :bright, cell_color]
            print Paint[' ] ', cell_color]
          end
          puts
        end
      elsif event[:type] == 'message'
        puts Paint[event[:message], :bright, 'orange']
      elsif event[:type] == 'variable'
        print Paint["#{event[:name]}", :underline, :bright, 'deep sky blue'], ': '
        puts Paint[event[:value].inspect, :bright, 'white']
      else
        p event
      end
    end
  end
end
