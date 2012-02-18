class Point
  attr_reader :x, :y
  @count = 100

  def initialize(x, y)
    @x = x
    @y = y
  end

  def +(other) # Define + to do vector addition
    Point.new(@x + other.x, @y + other.y)
  end

  def -@ # Define unary minus to negate both coordinates
    Point.new(-@x, -@y)
  end

  def *(scalar) # Define * to perform scalar multiplication
    Point.new(@x*scalar, @y*scalar)
  end

  def coerce(other)
    p "coerce function of Point"
    [self, other]
  end

  def Point.here()
  end

  def Point.sum(*points)
  end

  def hi()
  end
  private :hi

  class << Point
    def two
      @two = 2
    end
  end
end

Point::NEGATIVE_POINT_X = Point.new(-1, 0)
