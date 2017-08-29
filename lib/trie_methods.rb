module InsertMethods
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
    node.children[letter] = Node.new(letter) unless node.children[letter]
  end
  
  def format(string)
    string.strip.split("\n")
  end
end

module SuggestMethods
  def find_word(node, prefix)
    push_word(node, prefix)
    reassign_node(node, prefix)
  end

  def reassign_node(node, prefix)
    yung_keys = node.children.keys
    yung_keys.each do |letter|
      child   = node.children[letter]
      concat  = prefix + letter
      find_word(child, concat)
    end
  end

  def push_word(node, prefix)
    @suggestions << prefix if node.is_word     
  end
  
  def clear_suggestions
    @suggestions = []
  end
end

module SelectMethods
  def select_sort(prefix)
    @select[prefix].sort_by {|a, b| b}
                   .reverse!
                   .map(&:first)
  end

  def create_key(key, word)
    @select[key] = {word => 1}    
  end

  def increment(key, word)
    if @select[key][word]
       @select[key][word] += 1
    else 
      @select[key][word] = 1   
    end 
  end
end