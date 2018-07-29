class Callstack
  OUTPUT_DIR = 'tmp/'
  OUTPUT_FILE = 'EavedropCall_stack.log'

  @@stack = {}
  @@max_method_name_length = 0

  class << self
    def push(hash_data)
      @@stack[hash_data[:method_name]] ||= []
      @@stack[hash_data[:method_name]] << hash_data[:last_call_line] unless @@stack[hash_data[:method_name]].include?(hash_data[:last_call_line])
      @@max_method_name_length = hash_data[:method_name].to_s.length if @@max_method_name_length < hash_data[:method_name].to_s.length
    end

    def list
      @@stack
    end

    def reset
      @@stack = {}
    end

    def output_path
      OUTPUT_DIR + OUTPUT_FILE
    end

    def dump(_file_path = output_path)
      FileUtils.mkdir_p OUTPUT_DIR
      open(_file_path, "w+") do |f|
        @@stack.each do |method_name, stacktraces|
          stacktraces.each do |stacktrace|
            f.puts "#{method_name.to_s.rjust(@@max_method_name_length)} : #{stacktrace}"
          end
        end
      end
    end
  end
end
