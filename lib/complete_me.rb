class CompleteMe
  attr_accessor :count
  
  def initialize
    @head        = Node.new
    @count       = 0
    @suggestions = []
  end

  def insert(word, node = @head)
    return if word.empty? || word.nil?
    letters = word.chars
    iterate_n_insert(word, node, letters)
  end

  def iterate_n_insert(word, node, letters)
    letters.each.with_index do |letter, index|
      create_node_if_absent(letter, node)
      node = node.children[letter]
      update_if_word(word, node, index)
    end
  end

  def update_if_word(word, node, index)
    if index == word.length - 1
      node.is_word = true
      @count +=1
    end
  end

  def create_node_if_absent(letter, node)
    if !node.children[letter]
      node.children[letter] = Node.new
    end
  end

  def populate(string)
    formatted = format(string)
    formatted.each { |word| insert(word) }
  end

  def format(string)
    string.strip.split("\n")
  end

  def suggest(prefix, node = @head)
    clear_suggestions
    letters = prefix.chars
    letters.each { |letter| node = node.children[letter] }
    find_word_traversal(node, prefix)
  end

  def find_word_traversal(node, prefix)
    @suggestions << prefix if node.is_word 
    yung_keys = node.children.keys
    yung_keys.each do |letter|
      child   = node.children[letter]
      concat  = prefix + letter
      find_word_traversal(child, concat)
    end
    return @suggestions
  end
  
  def clear_suggestions
    @suggestions = []
  end
end