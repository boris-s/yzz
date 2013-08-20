 # Yzz

`Yzz` is a domain model of Ted Nelson's Zz structures. 

## Usage

The following usage example takes use of `y_support/name_magic` features.
Please install [y_support gem] before trying it.
```ruby
  require 'yzz'
  require 'y_support/name_magic'

  # Let's establish a new class and imbue it with Yzz quality.
  #
  class Cell
    include Yzz, NameMagic
    def to_s
      name ? name.to_s : "#<Cell: #{connections.size} conn.>"
    end
  end

  # Let's create 6 new cells.
  A1, A2, A3, B1, B2, B3 = 6.times.map { Cell.new }

  # And let's connect them along :x and :y dimensions:
  A1.along( :x ) >> A2 >> A3
  B1.along( :x ) >> B2 >> B3
  A1.along( :y ) >> B1
  A2.along( :y ) >> B2
  A3.along( :y ) >> B3

  # The Zz structure that we have created looks like this:
  #
  #   a1 --> a2 --> a3
  #   |      |      |
  #   |      |      |
  #   v      v      v
  #   b1 --> b2 --> b3
  #
  # The above structure is a little bit like a small spreadsheet 3×2.

  # The structure can be investigated:
  A1.neighbors # gives all the neighbors of A1
  #=> [A2, B1]
  A1.towards A2 # returns all the sides of A1 facing A2
  #=> [#<Yzz::Side: A1 along x, posward>]
  A1.tw A2 # more concise way of showing the sides facing A2
  #=> x->
  A1.tw B1
  #=> y->

  # Of course, more complicated Zz structures can be created. See the [online
  # presentation at xanadu.com for more](http://xanadu.com/zigzag/). For a small
  # example here, let's create 2 diagonal connections:

  A1.along( :diagonal ) >> B2
  A2.along( :diagonal ) >> B3
  A1.tw B2
  #=> diagonal->
  A1.neighbors
  #=> [A2, B1, B2]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
