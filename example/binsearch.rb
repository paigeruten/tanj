def binsearch(ary, x)
  left = 0
  right = ary.length - 1
  while left < right
    middle = (left + right) / 2
    if ary[middle] == x
      return middle
    elsif ary[middle] < x
      left = middle + 1
    elsif ary[middle] > x
      right = middle - 1
    else
      # unreachable
    end
  end
  nil
end

ary = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
idx = binsearch(ary, ARGV.first.to_i)

p idx
