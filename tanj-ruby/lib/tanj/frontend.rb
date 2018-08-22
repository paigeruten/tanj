module Tanj
  class Frontend
    def initialize(options = {})
      @options = options
      @events = []
    end

    def receive(line)
      return unless line.start_with? "tanj| "

      event = JSON.parse(line[6..-1], symbolize_names: true)
      @events.push event

      print_event(event) unless @options[:step]
    end

    def no_more!
      tui if @options[:step] && !@events.empty?
    end

    def print_event(event)
      if event[:type] == 'array'
        ary = event[:value]
        if ary.empty?
          puts Paint['<empty array>', 'dark gray']
        else
          colors = ['white', 'green', 'yellow', 'orange']

          Array(event[:options][:index]).each.sort_by do |target_idx|
            target_idx.is_a?(Array) ? target_idx[1][:value] - target_idx[0][:value] + 2 : 1
          end.each.with_index do |target_idx, target_layer|
            if target_idx.is_a?(Array)
              target_idx.each do |idx_var|
                print_var(idx_var, colors[target_layer + 1])
              end
            else
              print_var(target_idx, colors[target_layer + 1])
            end
          end

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
            cell_color = colors[idx_layer]
            print Paint['[ ', cell_color]
            print Paint[val.inspect, :bright, cell_color]
            print Paint[' ] ', cell_color]
          end
          puts
        end
      elsif event[:type] == 'message'
        puts Paint[event[:message], :bright, 'orange']
      elsif event[:type] == 'variable'
        print_var(event)
      else
        p event
      end
    end

    def print_var(obj, color = 'deep sky blue')
      print Paint["#{obj[:name]}", :underline, :bright, color], ': '
      puts Paint[obj[:value].inspect, :bright, 'white']
    end

    def tui
      i = 0
      loop do
        puts Paint["Event #{i+1}/#{@events.length}", :underline, :bright, 'sky blue']

        event = @events[i]

        if event[:where]
          file_lines = File.readlines(event[:where][:path])
          line_num = event[:where][:line_num]
          (line_num-5).upto(line_num+5) do |j|
            if 1 <= j && j <= file_lines.length
              line = "% #{line_num.to_s.length + 1}d %s #{file_lines[j-1]}" % [j, line_num == j ? '>' : '|']

              if line_num == j
                print Paint[line, :bright, 'white']
              else
                print Paint[line, 'gray']
              end
            end
          end
        end

        print_event(event)

        print '> '
        $stdin.gets

        break if i + 1 >= @events.length
        i += 1
      end
    end
  end
end
