require "spec_helper"

describe "basics" do
  it "Objects representing the same contents are not equal by default" do
    point1 = Point.new(10, 20)
    point2 = Point.new(10, 20)
    # Two objects with the same contents are not equal
    # They are compared with the object identify
    point1.hash.should_not == point2.hash
    point1.hash.should_not === point2.hash
    point1.eql?(point2).should == false
  end
  
  it "=== and is_a? are alike" do
    point3d = Point3D.new(10, 20, 30)
    # Compares with the object identify and they are not equivalent
    (point3d == Point3D).should_not == true
    # Class inheritance counts here
    (Point === point3d).should == true
    point3d.is_a?(Point).should == true
  end
  
  it "Ruby's superclass chain" do
    # Point3D => Point => Object => BasicObject
    Point3D.superclass.should == Point
    Point.superclass.should == Object
    Object.superclass.should == BasicObject
    BasicObject.superclass.should == nil
    
    # Class => Module => Object => BasicObject
    Class.superclass.should == Module
    Module.superclass.should == Object
    Object.superclass.should == BasicObject
    BasicObject.superclass.should == nil

    # Point3D's superclass is Point    
    Point3D.ancestors.should_not include(Module)
    # Point3D.class is Class
    Point3D.class.ancestors.should include(Module)
  end
  
  it "metaclass / singleton class hierarchy......" do
    class << Point3D
      self.class.should == Class	
      self.to_s.should == "#<Class:Point3D>"
      self.superclass.to_s.should == "#<Class:Point>"
      self.superclass.class == Class
      self.superclass.superclass.to_s.should == "#<Class:Object>"
      self.superclass.superclass.class.should == Class 
      self.superclass.superclass.superclass.to_s.should == "#<Class:BasicObject>"
      self.superclass.superclass.superclass.class.should == Class 
      # the superclass of #<Class:BasicObject> is Class !!!
      self.superclass.superclass.superclass.superclass.to_s.should == "Class"
      self.superclass.superclass.superclass.superclass.class.should == Class
      self.superclass.superclass.superclass.superclass.superclass.to_s.should == "Module"
      self.superclass.superclass.superclass.superclass.superclass.class.should == Class 
    end
  end
  
  it "self is mysterious......" do
    class << Point
      def get_self
        self
      end
    end
    
    point = Point.new(10, 20)
    point.object_id.should_not == Point.get_self.object_id
    point.object_id.should_not == Point.object_id
    Point.get_self.object_id.should == Point.object_id
  end  
  
  it "Object and Class dymistified" do
    # Class and Object are objects of Class class representing the Class and Object classes respectively
    # Class is a descendant of Object from the class inheritance perspective (Class => Module => Object)
    Class.is_a?(Object).should == true
    Object.is_a?(Class).should == true
    # Kernel is included in Object class
    Class.is_a?(Kernel).should == true
    Object.is_a?(Kernel).should == true
    
    # Class and Object are objects of Class class
    Class.instance_of?(Object).should_not == true
    Class.instance_of?(Class).should == true
    Object.instance_of?(Object).should_not == true
    Object.instance_of?(Class).should == true
    
    # String is an object of Class class representing the String class
    # Class is a descendant of Object from the class inheritance perspective (Class => Module => Object)
    # Kernel is included in Object class
    String.is_a?(Object).should == true
    String.is_a?(Kernel).should == true
    String.is_a?(Class).should == true
    # String is an object of Class class, not an object of String class
    String.is_a?(String).should_not == true
  end
  
  it "Another way to define class instance variables" do
    # Checks Point source code, a standard way to define the class instance variable
    Point.instance_variable_defined?(:@count).should == true
    
    # Instance variable :@two has not been brought to life
    Point.instance_variable_defined?(:@two).should_not == true
    # Brings the :@two instance variable to life
    Point.two
    # Now :@two is a class instance variable of Point
    Point.instance_variable_defined?(:@two).should == true
    # Class instance variable is not accessible from the subclass
    Point3D.instance_variable_defined?(:@two).should_not == true
  end
  
  # Module.nesting is lexical-based
  it "Module.netsting is lexical-based" do
    module M
      class C
        Module.nesting.should == [M::C, M]
      end
    end
  end
  
  # instance_eval runs at the instance-level
  # It creates a singleton method for an object or a class
  it "instance_eval" do
    point = Point.new(10, 20)
    point.instance_eval("def move; ; end")
    # :move is a singleton method of object point only
    Point.public_instance_methods.should include(:+)
    Point.public_instance_methods.should_not include(:move)
    Point.singleton_methods.should include(:here)
    Point.singleton_methods.should_not include(:move)
    # Invokes :move on the point object
    point.move.should == nil
    
    # Removes the singleton method :move
    class << point
      remove_method(:move)
    end
    
    # :bounce is a singleton method of Point class
    Point.instance_eval("def bounce; ; end")
    Point.public_instance_methods.should_not include(:bounce)
    Point.singleton_methods.should include(:bounce)
    
    # Removes the class method :bounce
    class << Point
      remove_method(:bounce)
    end
  end
  
  # class_eval runs at the module- / class-level
  it "class_eval" do
    # :show is an instance method of Point class
    Point.class_eval("def show; ; end")
    Point.public_instance_methods.should include(:show)
    Point.singleton_methods.should_not include(:show)    
    
    # Removes the instance method :show
    Point.send :remove_method, :show
    
    # Defines an instance method :add_them_up
    Point.class_eval {
      define_method(:add_them_up) { |pos| 
        @x + @y + pos
      }
    }
    point = Point.new(10, 20)
    point.add_them_up(30).should == 60
    # Removes the instance method :add_them_up
    Point.send :remove_method, :add_them_up
  end
  
  # instance_exec evaluates a block of code at the instance-level
  it "instance_exec" do    
    point = Point.new(10, 20)
    point.instance_exec(100) { |factor|
      factor * @x + @y
    }.should == 1020
  end
  
  # const_missing can be very interesting......
  it "const_missing" do
    def Point.const_missing(name)
      name
    end
    Point::WHERE.should == :WHERE
  end
  
  # method_missing can be very interesting......
  it "method_missing" do
    Point.class_eval {
      def method_missing(m, *args, &block)
        args[0]
      end
    }
    
    point = Point.new(10, 20)
    point.what(30).should == 30
  end
  
  # Ruby 1.9, block parameter assignment is not the same as the parallel assignment
  it "Ruby 1.9 block assignment is not the same as the parallel assignment" do
    def two; yield 10, 20; end
    
    # With the parallel assignment, x = 10, 20 will turn x to [10, 20]
    two do |x|
      x.should == 10
    end
    
    # Uses the * to group the values together
    two do |*x|
      x.should == [10, 20]
    end
  end
    
  # Ruby 1.9 new block syntax allowing default values assigned to parameters
  it "Ruby 1.9, new block synatx allowing default values assigned to parameters" do
    [1, 2, 3].each &->(x, y = 10) { (x * y). should == x * 10 }  
  end
  
  # Ruby 1.9 new lambda literal syntax
  it "Ruby 1.9, new lambda literal syntax" do
    l = ->(x) { x * x }
    l.call(100).should == 100 * 100
    
    # prefix the lambda literal with & when using it like a block
    [10, 20, 30].each &->(x, y = 100) {  (x + y ).should == x + 100}
  end
  
  # Proc equality
  it "Proc equality" do
    (lambda { |x| x*x } == lambda { |x| x*x }).should_not == true
    
    p = lambda { |x| x * x}
    q = p.dup
    p.should == q
    # Duplicated object is still a distinct one compared to the original
    p.object_id.should_not == q.object_id
  end
  
  # return within a proc or a lambda behaves differently
  it "return behaviour within a proc or a lambda is different" do
    def makeProc(num)
      Proc.new { |x| return x * num}
    end
    
    def makeLambda(num)
      lambda { |x| return x * num }
    end
    
    def one(&p)
      [1, 3, 5].inject(0) { |total, x| 
        r = p.call(x)
        total += r
      }
    end
    
    def two(&p)
      [1, 3, 5].inject(0) { |total, x| 
        r = yield x
        total += r
      }
    end   
    
    # return within a proc might cause the LocalJumpError exception
    # The lexically enclosing method makeProc has already returned
    p = makeProc(1)
    lambda{ p.call(1) }.should raise_error(LocalJumpError)
    lambda{ one(&p) }.should raise_error(LocalJumpError)
    lambda{ two(&p) }.should raise_error(LocalJumpError)
    
    # return within a lambda works like the return of a method invocation
    l = makeLambda(1)
    l.call(1).should == 1
    one(&l).should == 9
    # Notices the difference of One and Two
    # call versus yield   
    lambda { two(&l).should }.should raise_error(LocalJumpError)
  end
  
  # break behaves differently within a proc or a lambda
  it "break behaviour within a proc or a lambda is different" do   
    def one(&p)
      [1, 3, 5].inject(0) { |total, x| 
        r = p.call(x)
        total += r
      }
    end
    
    def two(&p)
      [1, 3, 5].inject(0) { |total, x| 
        r = yield x
        total += r
      }
    end
    
    # break causes the iterator to return
    result = one { |x| break x * x }
    result.should == 1
    
    p = Proc.new { |x| break x * x }
    lambda{ p.call(10) }.should raise_error(LocalJumpError)
    lambda{ one(&p) }.should raise_error(LocalJumpError)
    lambda{ two(&p) }.should raise_error(LocalJumpError)
    
    l = lambda { |x| break x * x }
    l.call(10).should == 100
    one(&l).should == 35
    # Notices the difference of One and Two
    # call versus yield
    lambda { two(&l).should }.should raise_error(LocalJumpError)
  end
  
  # next behaves the same within a proc or a lambda
  it "next behaviour within a proc or a lambda is the same" do
    def one(&p)
      [1, 3, 5].inject(0) { |total, x| 
        r = p.call(x)
        total += r
      }
    end
    
    def two(&p)
      [1, 3, 5].inject(0) { |total, x| 
        r = yield x
        total += r
      }
    end
    
    # next causes the yield statement to return or the call of the proc to return
    result = one { |x| next x * x }
    result.should == 35
    
    # next causes the yield statement to return or the call of the proc to return
    p = Proc.new { |x| next x * x }
    one(&p).should == 35
    two(&p).should == 35
   
    # next causes the yield statement to return or the call of the proc to return
    l = lambda { |x| next x * x }
    one(&l).should == 35
    two(&l).should == 35
  end
  
  it "Hooks......" do
    module Strict
      def singleton_method_added(name)
        eigenclass = class << self; self; end
        eigenclass.class_eval {
          # Supposedly, we don't need "unless" here
          remove_method name unless name.eql?(:singleton_method_added)
        } 
      end
    end
    
    point = Point.new(10, 20)
    
    # Adds a singleton method to the object
    # It should not invoke the singleton_method_added method of Strict
    def point.guess
    end   
    point.singleton_methods.should include(:guess)
    
    # Removes the newly added method
    class << point
      remove_method :guess
    end
   
    # Includes the Strict module 
    class Point
      include Strict
      def Point.singleton_method_added(name)
        eigenclass = class << self; self; end
        eigenclass.class_eval { 
          # The singleton_method_added gets called even when the Point.singleton_method_added 
          # is defined at the very first time
          remove_method name unless name.eql?(:singleton_method_added)
        }
      end
    end
    
    # Adds a singleton method to the Class
    # It should not invoke the sigleton_method_added method of strict
    def Point.what
    end
    Point.singleton_methods.should_not include (:what)
 
    # Adds a singleton method to the object
    # It should invoke the singleton_method_added method of Strict
    def point.what
    end
    point.singleton_methods.should_not include (:what)
  end
end
