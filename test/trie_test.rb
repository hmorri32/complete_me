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

  def test_populate_method_txt
    @trie.populate_txt('test/data/medium.txt')

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
    @trie.populate_csv('test/data/addresses.csv')
    assert_equal 306013, @trie.count
  end

  def insert_words(words)
    @trie.populate(words.join("\n"))
  end

  def test_delete_first
    @trie.insert('cool') 
    @trie.insert('cooler') 
    @trie.insert('cools') 
    cool = @trie.head.children['c'].children['o'].children['o'].children['l']
    
    assert cool.is_word    
    
    @trie.delete('cool')

    assert_equal 2, @trie.count 
    refute cool.is_word
  end

  def test_delete_middle
    @trie.insert('cool') 
    @trie.insert('cooler') 
    @trie.insert('cools') 

    cooler = @trie.head.children['c'].children['o'].children['o'].children['l'].children['e'].children['r']
    
    assert cooler.is_word    
    
    @trie.delete('cooler')

    assert_equal 2, @trie.count 
    refute cooler.is_word
  end

  def test_delete_coolers
    @trie.insert('cool') 
    @trie.insert('cooler') 
    @trie.insert('coolers') 
    @trie.insert('cools') 
    @trie.insert('banana')

    coolers = @trie.head.children['c'].children['o'].children['o'].children['l'].children['e'].children['r'].children['s']
    
    assert coolers.is_word    
    
    @trie.delete('coolers')
    @trie.delete('banana')

    assert_equal 3, @trie.count 
    refute coolers.is_word
  end

  def test_delete_end
    @trie.insert('cool') 
    @trie.insert('cooler') 
    @trie.insert('coolers') 
    @trie.insert('cools') 
    @trie.insert('banana')

    cools = @trie.head.children['c'].children['o'].children['o'].children['l'].children['s']

    @trie.delete('cools')
    @trie.delete('banana')
    
    assert_equal 3, @trie.count 
    refute cools.is_word
  end

  def test_delete_and_insert_and_delete
    @trie.insert('cool')
    @trie.insert('cooler')

    @trie.delete('cooler')
    
    assert_equal 1, @trie.count

    @trie.insert('cooler')

    assert_equal 2, @trie.count
    
    @trie.delete('cool')

    assert_equal 1, @trie.count 

    @trie.insert('cool')

    @trie.delete('cooler')

    assert_equal 1, @trie.count
  end

  def test_delete_extra_letters
    @trie.insert('cool')
    @trie.insert('cooler')
    
    assert_equal 'r', @trie.head.children['c'].children['o'].children['o'].children['l'].children['e'].children['r'].value

    @trie.delete('cooler')

    assert_nil @trie.head.children['c'].children['o'].children['o'].children['l'].children['e']
  end
end