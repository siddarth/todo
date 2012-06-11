require 'rubygems'
require 'logger'
require 'highline/system_extensions'
require 'colorize'
require 'yaml'
require File.expand_path('../task', __FILE__)
require File.expand_path('../command', __FILE__)

include HighLine::SystemExtensions

class TodoManager
  VERSION = '0.0.0'
  COMMANDS = [Command.new('k', :key_up),
              Command.new('j', :key_down),
              Command.new('a', :add_task, 'Enter the task: '),
              Command.new('s', :add_subtask, 'Enter the subtask: '),
              Command.new('x', :toggle_task),
              Command.new('d', :delete_task, 'Delete? [yN]: '),
              Command.new('q', :quit, 'Quit? [yN]: ')]

  def initialize(config=nil)
    @config = load_config(config) unless config.nil?
    @list = [Task.new("Drink coffee"), Task.new("Buy milk"), Task.new("Check out Sugar cafe")]
    @current = 0
    @num_tasks = 0
  end

  def main()
    clear_screen()
    loop do
      cmd = get_character
      run_cmd(cmd)
    end
  end

  private

    def load_config(config)
      YAML.load_file(config)
    end

    def clear_screen()
      system('clear')
    end

    def run_cmd(sc)
      command = COMMANDS.find { |c| c.shortcut == sc.chr }
      return if command.nil?
      print_list(command.ask)
      case command.desc
      when :key_up
        @current -= 1 unless @current.zero?
      when :key_down
        @current += 1 unless @current == @list.length - 1
      when :toggle_task
        el = @list[@current]
        el.done = !el.done
      when :add_task
        task = STDIN.readline.chomp
        @num_tasks += 1
        @list << Task.new(task) unless task == ''
      when :add_subtask
        subtask = STDIN.readline.chomp
        @num_tasks += 1
        return unless subtask == ''
      when :delete_task
        @num_tasks -= 1
        @list.delete_at(@current) if STDIN.readline.chomp == 'y'
      when :quit
        if STDIN.readline.chomp == 'y'
          puts 'Exiting!'
          exit(0)
        end
      end
      clear_screen()
      print_list()
    end

    def print_list(ask=nil)
      puts ' '*50
      print_header()
      @list.each_with_index do |el, i|
        print_el(el, @current == i)
      end
      if @list.empty?
        puts "No tasks found."
      end
      print_footer()
      puts ' '*50
      print ask unless ask.nil?
      STDOUT.flush
    end

    def print_el(el, current, depth=0)
      task = el.task
      out = '\t'*depth
      out << checkbox(el) + ' '
      if current
        out << format_current(task)
      else
        out << task
      end
      el.subtasks.each { |t| print_el(t, current, depth + 1)}
      puts out + ' '*(50-out.length)
    end

    def print_header()
      banner = " TodoManager (v.#{VERSION}) "
      out = ''
      num_dashes = (50 - banner.length)/2
      out << '-'*num_dashes
      out << "#{banner.colorize(:color => :black, :background => :white)}"
      out << '-'*(50 - (banner.length + num_dashes))
      puts out
    end

    def print_footer()
      puts '-'*50
      COMMANDS.each do |c|
        puts "[#{c.shortcut}] #{c.desc.to_s.gsub('_', ' ').capitalize}"
      end
      puts '-'*50
    end

    def format_current(str)
      str.colorize(:background => :red)
    end

    def checkbox(el)
      if el.done then '[X]' else '[ ]' end
    end
end