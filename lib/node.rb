class Node
  attr_accessor :is_word, :children, :value

  def initialize(value = nil)
    @value    = value
    @is_word  = false
    @children = {}
  end
end