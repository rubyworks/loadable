# Load all specs.
Dir['./spec/*_spec.rb'].each do |spec|
  require spec
end

