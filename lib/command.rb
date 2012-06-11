class Command
  attr_reader :shortcut, :desc, :ask

  def initialize(shortcut, desc, ask=nil)
    @shortcut, @desc, @ask = shortcut, desc, ask
  end
end