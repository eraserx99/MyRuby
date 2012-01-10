module My
  def self.hello
    p "Hello, world! This is My!"
  end

  def say_hello
    p "Say Hello!"
  end
  private :say_hello

  module_function
  def hello2
    p "Hello2, world! This is My!"
  end
end
