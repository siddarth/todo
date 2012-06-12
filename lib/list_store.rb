require 'yaml'
require File.expand_path('task', File.dirname(__FILE__))

class ListStore
  class << self
    STORE_PATH = File.expand_path('../log', File.dirname(__FILE__))

    def store(list)
      task_list = list.map { |t| t.to_hash }
      output = YAML.dump({'tasks' => task_list})
      File.open(filename, 'w') do |file|
        file.write(output)
      end
    end

    def latest_list
      return current_list unless current_list.nil?
      files = Dir.entries(STORE_PATH).find_all { |e| e.end_with?('yaml') }.sort
      files.delete(filename)
      latest = files.last
      return if latest.nil?
      tasks_from_fname(File.join(STORE_PATH, latest), true)
    end

    private

      def current_list
        return unless File.exists? filename
        tasks_from_fname(filename)
      end

      def filename
        fname = Time.now.strftime('%Y%m%d') + '.yaml'
        File.join(STORE_PATH, fname)
      end

      def tasks_from_fname(fname, done=false)
        tasks = YAML.load_file(fname)['tasks']
        return if tasks.nil?
        tasks = tasks.find_all { |t| t['done'] != true } if done
        tasks.map { |t| Task.from_hash(t) }
      end
  end
end
