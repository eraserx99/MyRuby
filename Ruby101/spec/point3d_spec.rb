require "spec_helper"

describe Point3D do
  it "Point3D can be initilized with x, y, and z coordinates" do
    point = Point3D.new(100, 200, 300)
    point.x.should eq(100)
    point.y.should eq(200)
    point.z.should eq(300)
  end
end