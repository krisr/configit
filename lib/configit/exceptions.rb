module Configit
  class ConfigitException < Exception; end
  class AttributeAlreadyDefined < ConfigitException; end
  class ArgumentError < ::ArgumentError; end
end
