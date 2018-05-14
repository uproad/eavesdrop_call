require "eve_drop_call/version"
require "callstack"

require 'fileutils'

module EveDropCall
  LOGGER = Callstack
  @@_target_klass_name = nil

  class << self
    def eavesdrop(_target_klass)
      @@_target_klass_name = _target_klass.to_s

      _i, _c = _prepend_gem_module(_target_klass)
      _target_klass.prepend(_i)
      _target_klass.singleton_class.prepend(_c)

      _target_klass
    end

    private

    def _prepend_gem_module(_target)
      _instance_methods = _target.instance_methods
      _class_methods = _target.singleton_class.instance_methods

      _instance_methods_module = Module.new do
        _instance_methods.each do |_method|
          next unless _method[0] =~ /[a-z|A-Z]/
          define_method(_method) do |*args, &block|
            LOGGER.puts "#{@@_target_klass_name}##{_method}"
            super(*args, &block)
          end
        end
      end

      _class_methods_module = Module.new do
        _class_methods.each do |_method|
          next unless _method[0] =~ /[a-z|A-Z]/
          define_method(_method) do |*args, &block|
            LOGGER.puts "#{@@_target_klass_name}.#{_method}"
            super(*args, &block)
          end
        end
      end

      return _instance_methods_module, _class_methods_module
    end
  end
end
