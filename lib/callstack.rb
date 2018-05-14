class Callstack
  OUTPUT_DIR = 'tmp/'
  OUTPUT_FILE = 'evedropcall_stack.log'

  @@stack = []
  @@max_method_name_length = 0

  class << self
    def push(hash_data)
      @@stack << hash_data
      @@max_method_name_length = hash_data[:method_name].to_s.length if @@max_method_name_length < hash_data[:method_name].to_s.length
    end

    def list
      @@stack
    end

    def reset
      @@stack = []
    end

    def output_path
      OUTPUT_DIR + OUTPUT_FILE
    end

    def dump(_file_path = output_path)
      FileUtils.mkdir_p OUTPUT_DIR
      open(_file_path, "w+") do |f|
        @@stack.each do |row|
          f.puts "#{row[:method_name].to_s.rjust(@@max_method_name_length)} : #{row[:last_call_path]}:#{row[:last_call_line]}"
        end
      end
    end
  end
end
