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
  include Math

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

begin
  point1.hello
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

begin
  point2.hello
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

Point3D.extend(My)

begin
  Point3D.hello
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

begin
  Point3D.hello2
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

Kernel.p "Hello, through Kernel.p"
p "Hello, through p directly"

include My

My.hello

begin
  hello
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

# check the "main" object
p self
p self.class

# hello2 is defined within module_function
# hello2 invoked as a class method
My.hello2
# hello2 invoked as a private instance method
hello2

module X
  module Y
    module Z
      include Math
      p Module.nesting
      p "Z.ancestors, " + Z.ancestors.to_s
    end
  end
end

p "Point3D.ancestors, " + Point3D.ancestors.to_s
p "Math.ancestors, " + Math.ancestors.to_s

# Have some fun here
p "Object is an instance of Class or decedents of Class" if Object.is_a? Class
p "The class of Object is, " + Object.class.to_s
p "Class is an instance of Object or decedents of Object " if Class.is_a? Object
p "The class of Class is, " + Class.class.to_s
p "Class is an instance of Class of decedents of Class" if Class.is_a? Class
p "String is an instance of String or decedents of String" if String.is_a? String
p "The class of String is, " + String.class.to_s

p "Done!"
