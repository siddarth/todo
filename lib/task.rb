class Task
  attr_reader :task, :created_at, :subtask
  attr_accessor :done, :subtasks

  def initialize(task)
    @is_done = false
    @task = task.chomp
    @created_at = Time.now
    @subtasks = Array.new
  end
end