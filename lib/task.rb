class Task
  attr_reader :task, :created_at, :subtask
  attr_accessor :done, :subtasks

  def initialize(task, done=false, created_at=Time.now)
    @done = done
    @task = task.to_s.chomp
    @created_at = created_at
  end

  def to_hash
    {'done' => @done,
     'task' => @task.to_s,
     'created_at' => @created_at.to_s}
  end

  class << self
    def from_hash(h)
      Task.new(h['task'], h['done'], h['created_at'])
    end
  end
end
