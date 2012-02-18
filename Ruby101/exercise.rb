class Point
  class << self 
    def hi1
      @x = 100
    end
    def hi2
      @x
    end
  end
  def guess
    @x
  end
end

class Point3D < Point
  class << self
    def hi3
    end
    p "====== within class << Point3D ======"
    p "self.instance_of?(Class) => #{self.instance_of?(Class)}"
    p "self => #{self}"
    p "self.superclass => #{self.superclass}"
    p "self.ancestors => #{self.ancestors}"
    p "self.methods => #{self.methods}" 
    p "self.methods(false) => #{self.methods(false)}" 
    p "self.public_instance_methods => #{self.public_instance_methods}"
    p "self.public_instance_methods(false) => #{self.public_instance_methods(false)}"
    p "self.singleton_methods => #{self.singleton_methods}"
    p "self.singleton_methods(false) => #{self.singleton_methods(false)}"
    p "====================================="
  end
  p "====== within Point3D < Point ======"
  p "self.instance_of?(Class) => #{self.instance_of?(Class)}"
  p "self => #{self}"
  p "self.superclass => #{self.superclass}"
  p "self.ancestors => #{self.ancestors}"
  p "self.methods => #{self.methods}"
  p "self.methods(false) => #{self.methods(false)}"
  p "self.public_instance_methods => #{self.public_instance_methods}"
  p "self.public_instance_methods(false) => #{self.public_instance_methods(false)}"
  p "self.singleton_methods => #{self.singleton_methods}"
  p "self.singleton_methods(false) => #{self.singleton_methods(false)}"
  p "===================================="
end

p "====== Point3D ======"
p "Point3D.instance_of?(Class) => #{Point3D.instance_of?(Class)}"
p "Point3D => #{Point3D}"
p "Point3D.ancestors => #{Point3D.ancestors}"
p "self.methods => #{self.methods}"
p "Point3D.public_instance_methods => #{Point3D.public_instance_methods}"
p "Point3D.singleton_methods => #{Point3D.singleton_methods}"
p "====================="

p "====== point ======"
point = Point3D.new
p "point.methods => #{point.methods}"
p "point.singleton_methods => #{point.singleton_methods}"
p "==================="

p "====== Class ======"
p "Class.ancestors => #{Class.ancestors}"
p "Class.methods => #{Class.methods}"
p "Class.methods(false) => #{Class.methods(false)}"
p "Class.public_instance_methods => #{Class.public_instance_methods}"
p "Class.public_instance_methods(false) => #{Class.public_instance_methods(false)}"
p "Class.singleton_methods => #{Class.singleton_methods}"
p "Class.singleton_methods(false) => #{Class.singleton_methods(false)}"

class << Module
  p self
  p self.superclass
end
