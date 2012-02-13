class Point3D < Point
  include Math
  attr_reader :z

  def initialize(x, y, z)
    super(x, y)
    @z = z
  end

  def hey
  end

  class << Point3D
    def Point3D.here()
    end
  end
end