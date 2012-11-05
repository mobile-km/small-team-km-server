class SortChar

  CHARS = [
    'A', 'B', 'C', 'D',
    'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L',
    'M', 'N', 'O', 'P',
    'Q'
  ]

  attr_reader :left, :right, :mid

  def initialize(left, right)
    # 获取端点
    @left  = left  || 'A'
    @right = right || 'Q'

    # 补齐长度到两边一致
    self.fix_length

    # 获取中值
    self.get_mid
  end

  def fix_length
    l = @left
    r = @right

    # 求最大长度
    @max_length = [l.length, r.length].max
    l_arr, r_arr = l.split(''), r.split('')

    # 逐项增补 A 或者 Q
    @max_length.times do |i|
      l_arr[i] ||= 'A'
      r_arr[i] ||= 'Q'
    end

    @left  = l_arr.join
    @right = r_arr.join
  end

  def get_mid
    l_arr, r_arr = @left.to_s.split(''), @right.to_s.split('')

    index_arr = []

    flag = false
    @max_length.times do |i|
      l_index = CHARS.index l_arr[i]
      r_index = CHARS.index r_arr[i]

      sum = l_index + r_index

      index_arr[i] = sum / 2

      if i == @max_length - 1
        flag = true if sum % 2 != 0
      end
    end

    @mid = index_arr.map{|idx| CHARS[idx]}.join
    @mid += 'I' if flag
  end

  def self.g(left, right)
    return SortChar.new(left, right).mid
  end

end