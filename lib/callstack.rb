class Callstack
  OUTPUT_DIR = 'tmp/'
  OUTPUT_FILE = 'evedropcall_stack.log'

  @@stack = []

  class << self
    def puts(message)
      @@stack << message
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
        @@stack.each do |line|
          f.puts line
        end
      end
    end
  end
end
