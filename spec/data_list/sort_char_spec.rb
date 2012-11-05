require 'spec_helper'

=begin 
  我们用17个字母构成的字符串来表示一个列表项的顺序位置
  A B C D E F G H I J K L M N O P Q
=end


describe SortChar do
  it '补齐端点长度' do
    s = SortChar.new(nil, nil)
    s.left.should  == 'A'
    s.right.should == 'Q'

    s = SortChar.new(nil, 'I')
    s.left.should  == 'A'
    s.right.should == 'I'

    s = SortChar.new('I', nil)
    s.left.should  == 'I'
    s.right.should == 'Q'

    s = SortChar.new(nil, 'CI')
    s.left.should  == 'AA'
    s.right.should == 'CI'

    s = SortChar.new('CI', 'D')
    s.left.should  == 'CI'
    s.right.should == 'DQ'
  end

  it '可以在空列表新增一项' do
    SortChar.g(nil, nil).should == SortChar.g('A', 'Q')
    SortChar.g(nil, nil).should == 'I'
  end

  it '可以在最前新增一项' do
    SortChar.g(nil, 'I').should == SortChar.g('A', 'I')
    SortChar.g(nil, 'I').should == 'E'

    SortChar.g(nil, 'E').should == SortChar.g('A', 'E')
    SortChar.g(nil, 'E').should == 'C'

    SortChar.g(nil, 'C').should == SortChar.g('A', 'C')
    SortChar.g(nil, 'C').should == 'B'

    SortChar.g(nil, 'B').should == SortChar.g('A', 'B')
    SortChar.g(nil, 'B').should == 'AI'

    SortChar.g(nil, 'D').should == SortChar.g('A',  'D')
    SortChar.g(nil, 'D').should == SortChar.g('AA', 'DQ')
    SortChar.g(nil, 'D').should == 'BI'
  end

  it '可以在中间插入一项' do
    cases = [
      ['E', 'G', 'I'],
      ['E', 'F', 'G'],
      ['E', 'EI', 'F'],
      ['E', 'FI', 'H'],
      ['E', 'EE', 'FI'],
      ['E', 'EC', 'EE'],
      [nil, 'CB', 'EC']
    ]

    cases.each do |arr|
      l = arr[0]
      r = arr[2]

      SortChar.g(l, r).should == arr[1]
    end

  end
end