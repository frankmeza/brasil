require './dependencies'

ENV['RACK_ENV'] ||= "development"
Mongoid.load!("#{Dir.pwd}/config/mongoid.yml")

Cuba.define do
  on get, root do
    res.write "hella lit"
  end
end
