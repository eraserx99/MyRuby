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
  
end
