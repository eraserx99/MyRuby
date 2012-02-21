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

def dump_superclass(s)
  begin
    p s
    s = s.superclass
  end until s == nil
end

class Point3D < Point
  class << self
    def hi3
    end
    class << self
      class << self
          class << self
              dump_superclass(self)
          end
      end
    end
    p "====== within class << Point3D ======"
    p "self.instance_of?(Class) => #{self.instance_of?(Class)}"
    p "self => #{self}"
    p "self.superclass => #{self.superclass}"
    p "self.superclass.superclass => #{self.superclass.superclass}"
    p "self.superclass.superclass.superclass => #{self.superclass.superclass.superclass}"
    p "self.superclass.superclass.superclass.superclass => #{self.superclass.superclass.superclass.superclass}"
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
p "Point3D.superclass => #{Point3D}"
p "Point3D.ancestors => #{Point3D.ancestors}"
p "self.methods => #{self.methods}"
p "Point3D.public_instance_methods => #{Point3D.public_instance_methods}"
p "Point3D.singleton_methods => #{Point3D.singleton_methods}"
p "====================="

p "====== point ======"
point = Point3D.new
p "point.class => #{point.class}"
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
  def singleton_for_module
  end
end

class << Class
  def singleton_for_class
  end
end

p "====== Point ======"
p "Point.singleton_methods => #{Point.singleton_methods}"

p "====== class << Point ======"
class << Point
  p "self.singleton_methods => #{self.singleton_methods}"
end

p "====== Class ======"
p "Class.singleton_methods => #{Class.singleton_methods}"

p "====== Module ======"
p "Module.singleton_methods => #{Module.singleton_methods}"

p "====== Object ======"
p "Object.singleton_methods => #{Object.singleton_methods}"

p "====== class << point ======>"
class << point
  def singleton_for_object
  end
  p self
  p self.superclass
  p self.public_instance_methods
  p self.singleton_methods
  class << self
    p self
    p self.superclass
    p self.singleton_methods
  end
end

p point.methods

p "====== Point3D ======"
p Point3D.public_instance_methods

