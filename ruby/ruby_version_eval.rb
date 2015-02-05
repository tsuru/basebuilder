class Mock < BasicObject
  ENV = ::ENV
  def method_missing(name, *args)
  end
  def ruby(*args)
    ::Kernel.puts args[0]
  end
end

Mock.new.instance_eval(File.read(ARGV[0]))
