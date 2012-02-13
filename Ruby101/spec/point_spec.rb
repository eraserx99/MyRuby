require "spec_helper"

describe Point do
  it "Point can be initilized with x and y coordinates" do
    point = Point.new(100, 200)
    point.x.should eq(100)
    point.y.should eq(200)
  end
  
end