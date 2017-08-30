module Methods
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

  def populate_csv(file)
    CSV.foreach(file) { |row| insert(row[-1]) }
  end

  def populate_txt(file)
    populate(File.read(file))
  end

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

  def select_sort(prefix)
    @selected[prefix].sort_by { |a, b| b }
                     .reverse!
                     .map(&:first)
  end

  def create_key(key, word)
    @selected[key] = {word => 1}    
  end

  def increment(key, word)
    if @selected[key][word]
       @selected[key][word] += 1
    else 
      @selected[key][word] = 1   
    end 
  end

  def exists?(word)
    letters = word.chars
    nodes   = letters.map { |letter| Node.new(letter) }
    node    = find_node(nodes)
    node.is_word ? true : false if node
  end

  def node_pop(nodes)
    node = nodes.pop
    return if node.nil? || node.is_word

    if node.children.empty?
      parent = nodes.last
      return if parent.nil?
      parent.children.delete(node.value)
    end
    node_pop(nodes)
  end

  def find_node(arr, node = @head)
    return false if node.nil?
    return @node_tank.last if arr.empty?
    last = arr.shift 
    @node_tank << node.children[last.value]
    find_node(arr, node.children[last.value])
  end
end