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
    (point3d == Point).should_not == true
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
  end
  
  it "self is mysterious......" do
    class Point
      def get_self
        self
      end
    end
    
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
    
    # :bounce is a singleton method of Point class
    Point.instance_eval("def bounce; ; end")
    Point.public_instance_methods.should_not include(:bounce)
    Point.singleton_methods.should include(:bounce)
  end
  
  # class_eval runs at the module- / class-level
  it "class_eval" do
    # :show is an instance method of Point class
    Point.class_eval("def show; ; end")
    Point.public_instance_methods.should include(:show)
    Point.singleton_methods.should_not include(:show)    
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
  
end
