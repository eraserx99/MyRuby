module My
  def say_hello
    p "This is My private say_hello"
  end
  private :say_hello

  def say_hello2
    p "This is My say_hello!"
  end

  def self.hello
    p "This is My self.hello!"
  end

  module_function
  def hello2
    p "This is My module function hello2!"
  end
end
