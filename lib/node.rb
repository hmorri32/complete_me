class Node
  attr_accessor :is_word, :children

  def initialize
    @is_word  = false
    @children = {}
  end
end