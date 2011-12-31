require "./my"

def dump(where, arg)
  raise ArgumentError if where == nil || arg == nil
  p "<<<<<<<<<<<<<<<<<<"
  p "where => " + where
  p "self => " + self.to_s
  p "self.class => " + arg.class.to_s
  p "self.object_id => " + arg.object_id.to_s
  p ">>>>>>>>>>>>>>>>>>"
end

class Class
  alias oldNew new

  def new(*args)
    dump("creating a new class instance", self)
    oldNew(*args)
  end
end

class Point
  attr_reader :x, :y

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
    [self, other]
  end

  def Point.here()
    dump("class method, here, of Point", self)
  end

  def Point.sum(*points)
    dump("class method, sum, of Point", self)
    here
  end

  def hi()
    dump("instance method, hi, of Point", self)
  end

  private :hi

  dump("somewhere within the Point class", self)

  class << Point
    dump("somewhere within class << Point", self)
  end

  class << Point
    dump("another place within class << Point", self)
  end
end

point1 = Point.new(10, 20)
p "point1.x: " + point1.x.to_s
p "point1.y: " + point1.y.to_s

point2 = 2*point1
p "point2.x: " + point2.x.to_s
p "point2.y: " + point2.y.to_s

Point::NEGATIVE_POINT_X = Point.new(-1, 0)
p Point::NEGATIVE_POINT_X

class Point3D < Point

  def initialize(x, y, z)
    super(x, y)
    @z = z
  end

  def hey
    dump("instance method, hey, of Point3D", self)
  end

  dump("somewhere within Point3D class", self)

  class << Point3D
    dump("somewhere within class<< Point3D", self)

    def Point3D.here()
      dump("class method, here, of Point3D", self)
    end
  end
end

point3 = Point3D.new(100, 200, 300)
point3.hey

Point.sum(point1)
# sum is defined in the parent class Point, not Point3D
Point3D.sum(point3)

o = Object.new
p 'yes' if String.is_a? String

point1.extend(My)
point1.hello

begin
  point2.hello
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

Point3D.extend(My)
Point3D.hello

begin
  Point3D.hello2
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

Kernel.p "Hello, through Kernel.p"
p "Hello, through Kernel.p"

include My
My.hello
My.hello2
hello2
