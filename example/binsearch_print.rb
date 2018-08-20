def binsearch(ary, x)
  left = 0
  right = ary.length - 1
  while left < right
    middle = (left + right) / 2
    puts "left = #{left}, right = #{right}, middle = #{middle}"
    puts "ary[middle] = #{ary[middle]}"
    if ary[middle] == x
      puts "found it!"
      return middle
    elsif ary[middle] < x
      puts "too small"
      left = middle + 1
    elsif ary[middle] > x
      puts "too large"
      right = middle - 1
    else
      puts "this should be unreachable!"
    end
    puts
  end
  puts "didn't find it"
  nil
end

ary = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
idx = binsearch(ary, ARGV.first.to_i)

puts "idx = #{idx.inspect}"
