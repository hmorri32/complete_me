require_relative 'require_helper'

class TrieTest < Minitest::Test

  def setup
    @trie = Trie.new
  end

  def test_exists_and_instance
    assert @trie 
    assert_instance_of Trie, @trie
  end

  def test_initialized_head
    assert_instance_of Node, @trie.head
  end

  def test_suggestions_start_empty 
    assert_equal [], @trie.suggestions
  end

  def test_insert
    @trie.insert('cool')
    @trie.insert('guy')

    assert_equal 2, @trie.count
  end

  def test_populate_array
    insert_words(['cool', 'stuff'])

    assert_equal 2, @trie.count
  end

  def test_suggests_off_of_small_dataset
    insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])
    
    assert_equal ["pizza"], @trie.suggest("p")
    assert_equal ["pizza"], @trie.suggest("piz")
    assert_equal ["zombies"], @trie.suggest("zo")
    assert_equal ["a", "aardvark"], @trie.suggest("a").sort
    assert_equal ["aardvark"], @trie.suggest("aa")
  end

  def test_suggest_small_data_set
    @trie.insert('cool')
    @trie.insert('suh')
    @trie.insert('surfboard')
    @trie.insert('skateboards')
    @trie.insert('burrito')
    @trie.insert('burritos')

    assert_equal ['burrito', 'burritos'], @trie.suggest('bur')
    assert_equal ['skateboards'], @trie.suggest('sk')
    assert_equal ['suh', 'surfboard'], @trie.suggest('su')
  end

  def test_populate_medium_txt
    @trie.populate(File.read("test/data/medium.txt"))

    assert_equal 1000, @trie.count
  end
  
  def test_populate_csv_small_file
    @trie.populate_csv('test/data/20_addresses.csv')

    assert_equal 20, @trie.count
  end
  
  def test_suggest_addresses
    @trie.populate_csv('test/data/20_addresses.csv')

    assert_equal ["16100 E 56th Ave", "19100 E 40th Ave"], @trie.suggest('1')
    assert_equal ["21541 E 44th Ave", "21563 E 44th Ave"], @trie.suggest('215')
  end

  def test_populate_csv_large_file
    skip
    # works but takes forever
    @trie.populate_csv('test/data/addresses.csv')
    assert_equal 306013, @trie.count
  end

  def insert_words(words)
    @trie.populate(words.join("\n"))
  end
end