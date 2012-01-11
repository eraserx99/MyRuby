require "./my"
require "thread"

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
    # dump("creating a new class instance", self)
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
    p "coerce function of Point"
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

  class << Point
    dump("within the Point metaclass class << Point", self)
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

  class << Point3D
    dump("within the Point3D metaclass class << Point3D", self)
    def Point3D.here()
      dump("class method, here, of Point3D", self)
    end
  end
end

Point3D.class_eval { def never_say_never; p "never_say_never from Point3D!"; end }

begin
  Point3D.class_eval {
    begin
      define_method(:never_say_never2) { p "never_say_nerver2 from Point3D!" }
    rescue =>ex
      p "#{ex.class}: #{ex.message}, come to rescue!"
    end
  }
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

begin
  Point3D.class_eval {
    begin
      p = Proc.new { p "never_say_nerver3 from Point3D!"}
      define_method(:never_say_never3, &p)
    rescue =>ex
      p "#{ex.class}: #{ex.message}, come to rescue!"
    end
  }
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

point3 = Point3D.new(100, 200, 300)
point3.hey
point3.never_say_never
point3.never_say_never2
point3.never_say_never3
p "50/50"

Point.sum(point1)
# sum is defined in the parent class Point, not Point3D
Point3D.sum(point3)

o = Object.new
p 'yes, String is_a String' if String.is_a? String
p 'yes, String is_a Object' if String.is_a? Object
p 'yes, String is_a Module' if String.is_a? Module
p 'yes, String is_a Class' if String.is_a? Class
# String is an instance of Class
p "String's class is => " + String.class.to_s
# 1 is an instance of Fixnum class
p "1's class is => " + 1.class.to_s

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

p "#################################"
p "public methods of Point3D"
p Point3D.public_instance_methods
p "private methods of Point3D"
p Point3D.private_instance_methods
p "singleton methods of Point3D"
p Point3D.singleton_methods
p "#################################"

class NoneSense
  include My
  def none_public
  end

  private
  def none_private
  end

  protected
  def none_protected
  end
end

p "#################################"
p "instance methods of NoneSense"
p NoneSense.instance_methods
p "public methods of NoneSense"
p NoneSense.public_instance_methods
p "private methods of NoneSense"
p NoneSense.private_instance_methods
p "singleton methods of NoneSense"
p NoneSense.singleton_methods
p "#################################"

ns = NoneSense.new
ns.say_hello2

Kernel.p "Hello, through Kernel.p"
p "Hello, through p directly"

include My

def test
end

p "#################################"
p "public methods of main object"
p self.public_methods
p "private methods of main object"
p self.private_methods
p "private class methods of the class of main object"
p self.class.singleton_methods
p "#################################"

My.hello

begin
  p "hello"
  hello
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

begin
  p "My.say_hello =>"
  My.say_hello
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

begin
  p "say_hello =>"
  say_hello
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

begin
  p "say_hello2 =>"
  self.say_hello2
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

# check the "main" object
p self
p self.class

# hello2 is defined within module_function
# hello2 invoked as a class method of the module My
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

class Object
  def eigenclass
    class << self
      self
    end
  end
end

p "Point3D's eigenclass => " + Point3D.eigenclass.to_s

begin
  p point3.binding.to_s
rescue => ex
  p "#{ex.class}: #{ex.message}, come to rescue!"
end

def Object.inherited(c)
  puts "inherited is called, class #{c} < #{self}"
end

class String2 < String
end

module Final
  def self.included(c)
    p "Final self.included!"
    c.instance_eval do
      def inherited(sub)
        p caller[0].to_s
        raise Exception, "Attempt to create subclass #{sub} of Final class #{self}"
      end
    end
  end

  def self.extended(o)
    p "Final self.extended!"
  end

  class << Final
    p "within the metaclass class << Final => " + self.to_s
  end
end

module Strict
  def singleton_method_added(name)
    p "singleton #{name} added to object, " + self.object_id.to_s
  end
end

class Object
  def test
    p self.class
  end
end

class String3 < String2
  include Final, Strict

  def self.singleton_method_added(name)
    p "New class method #{name} is added to " + self.to_s
  end

end

p "#################################"
p "public methods of String3"
p String3.public_instance_methods
p "private methods of String3"
p String3.private_instance_methods
p "singleton methods of String3"
p String3.singleton_methods
p "#################################"

def String3.new_s_method()
end

s3 = String3.new
def s3.another_s_method()
end

class << s3
  p "really, " + self.to_s
end

begin
  class String4 < String3
  end
  rescue Exception => ex
    p "#{ex.class}: #{ex.message}, come to rescue!"
end

p "#################################"
p "public methods of My"
p My.public_instance_methods
p "private methods of My"
p My.private_instance_methods
p "singleton methods of My"
p My.singleton_methods
p "#################################"

String3.instance_eval { @oh_string3 = "string3" }
String3.instance_eval { p @oh_string3 }

String3.instance_eval { def really? ; p "this is @oh_string3 #{@oh_string3}"; end }
String3.really?

class String3
  def common
    # @oh_string3 is not an instance variable of String3
    # nil should be the value expected
    p @oh_string3
  end
end

s3 = String3.new
p "s3.class.to_s => #{s3.class.to_s}"
s3.common

class String4 < String3
  def to_s
    p "I'm an object of String4"
  end
  def still
    p "still of String4"
    if block_given?
      yield
    end
  end
end

class << String4
  p self.to_s
  p self.superclass.to_s
  p self.class.to_s
  p self.superclass.class.to_s

  p "#################################"
  p "public methods of class << String4"
  p self.public_instance_methods
  p "private methods of class << String4"
  p self.private_instance_methods
  p "singleton methods of class << String4"
  p self.singleton_methods
  p "#################################"

  def hi
    @oh_string3 = "hi"
  end
end

# instance variables are not inherited
# they come to live when they're assigned with values
# usually, it's done within the "inherited" methods
# expect nothing from @oh_string3 instance variable unless String4.hi is called first
String4.really?

def synchronized(o)
  if block_given?
    o.mutex.synchronize { yield }
  else
    SynchronizedObject.new(o)
  end
end

class SynchronizedObject < BasicObject
  def initialize(o)
    @delegate = o
  end
  def __delegate
    @delegate
  end
  def method_missing(*args, &block)
    @delegate.mutex.synchronize {
      @delegate.send *args, &block
    }
  end
end

class Object
  def mutex
    return @__mutex if @__mutex
    synchronized(self.class) {
      @__mutex = @__mutex || Mutex.new
    }
  end
end

Class.instance_eval { @__mutex = Mutex.new }

s4 = String4.new
s4.test

synchronized(s4) {
  p "within the synchronized block!!!"
}

s4 = synchronized(s4)
s4.still
s4.still { p "hihihi!"}

m = Mutex.new
a = Thread.new {
  m.synchronize {

  }
}

sleep(3)

p "Done!"
