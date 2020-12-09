require "cloudconvert/base"
require "equalizer"

module CloudConvert
  class Entity < CloudConvert::Base
    include Equalizer.new(:id)
  end
end
