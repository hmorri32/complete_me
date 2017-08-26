class CompleteMe
  attr_accessor :count
  
  def initialize
    @head = Node.new
    @count = 0
    @suggestions = []
  end

  def insert(word, node = @head)
    return if word.empty? || word.nil?
    letters = word.chars
    iterate_n_insert(word, node, letters)
  end

  def iterate_n_insert(word, node, letters)
    letters.each.with_index do |letter, index|
      letter = word[index]
      create_node_if_absent(letter, node)
      node = node.children[letter]
      if index == word.length - 1
        node.is_word = true
        @count +=1
      end
    end
  end

  def create_node_if_absent(letter, node)
    if !node.children[letter]
      node.children[letter] = Node.new
    end
  end
end