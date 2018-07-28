require "eve_drop_call/version"
require "callstack"

require 'fileutils'

module EveDropCall
  LOGGER = Callstack
  @@target_klass_name = nil

  class << self
    def eavesdrop(target_klass, called_dir_path = File.expand_path(File.dirname(__FILE__)))
      @@target_klass_name = target_klass.to_s
      @@current_dir = called_dir_path

      instance_methods, class_methods = prepend_gem_module(target_klass)
      target_klass.prepend(instance_methods)
      target_klass.singleton_class.prepend(class_methods)

      target_klass
    end

    private

    def prepend_gem_module(target)
      instance_methods = target.instance_methods
      class_methods = target.singleton_class.instance_methods

      instance_methods_module = Module.new do
        instance_methods.each do |method|
          next unless method[0] =~ /[a-z|A-Z]/
          define_method(method) do |*args, &block|
            trace_first = caller.find{|p| p.start_with?(@@current_dir) }
            LOGGER.push({ method_name: "#{method} [I]", last_call_line: trace_first }) if trace_first
            super(*args, &block)
          end
        end
      end

      class_methods_module = Module.new do
        class_methods.each do |method|
          next unless method[0] =~ /[a-z|A-Z]/
          define_method(method) do |*args, &block|
            trace_first = caller.find{|p| p.start_with?(@@current_dir) }
            LOGGER.push({ method_name: "#{method} [C]", last_call_line: trace_first }) if trace_first
            super(*args, &block)
          end
        end
      end

      return instance_methods_module, class_methods_module
    end
  end
end
