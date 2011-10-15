class Module
  def module_require(child)
    child = child.to_s.gsub('::','/').downcase
    path  = name.to_s.gsub('::','/').downcase
    path  = File.join(path, child)
    require_relative(path)
  end
  alias_mehtod :class_require, :module_require
end

