require 'yaml'
require File.expand_path('task', File.dirname(__FILE__))

class ListStore
  class << self
    STORE_PATH = File.expand_path('todo', File.dirname(__FILE__))

    def store(list)
      filename = Time.now.strftime('%Y%m%d') + '.yaml'
      task_list = list.map { |t| t.to_hash }
      output = YAML.dump({'tasks' => task_list})
      puts output.inspect
      File.open(filename, 'w') do |file|
        file.write(output)
      end
    end

    def get_last_list
      files = Dir.entries('.').find_all { |e| e.end_with?('yaml') }.sort
      files.reverse.each do |f|
        begin
          tasks = YAML.load_file(f)['tasks']
          next if tasks.nil?
          unfinished = tasks.find_all { |t| t['done'] != true }
          return unfinished.map { |t| Task.from_hash(t) }
        rescue
          raise
        end
      end
    end
  end
end
