$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'tanj'

def binsearch(ary, x)
  left = 0
  right = ary.length - 1
  while left < right
    middle = (left + right) / 2
    Tanj.array(ary, "ary", highlight: { yellow: left..right, green: middle })
    if ary[middle] == x
      Tanj.message "found it!"
      return middle
    elsif ary[middle] < x
      Tanj.message "too small"
      left = middle + 1
    elsif ary[middle] > x
      Tanj.message "too large"
      right = middle - 1
    else
      # unreachable
      Tanj.message "this should be unreachable!"
    end
  end
  Tanj.message "didn't find it"
  return nil
end

ary = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
idx = binsearch(ary, ARGV.first.to_i)

Tanj.var idx, "idx"
