class Node
  attr_accessor :is_word, :children, :value

  def initialize(value)
    @value    = value
    @is_word  = false
    @children = {}
  end

  def word_toggle 
    @is_word = !@is_word
  end
end