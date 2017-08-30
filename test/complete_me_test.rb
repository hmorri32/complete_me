require_relative 'require_helper'

class CompleteMeTest < Minitest::Test
  attr_reader :cm

  def setup
    @cm = CompleteMe.new
  end

  def test_starting_count
    assert_equal 0, cm.count
  end

  def test_inserts_single_word
    cm.insert("pizza")
    
    assert_equal 1, cm.count
  end

  def test_inserts_multiple_words
    cm.populate("pizza\ndog\ncat")
    
    assert_equal 3, cm.count
  end

  def test_counts_inserted_words
    insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])
    
    assert_equal 5, cm.count
  end

  def test_suggests_off_of_small_dataset
    insert_words(["pizza", "aardvark", "zombies", "a", "xylophones"])
    
    assert_equal ["pizza"], cm.suggest("p")
    assert_equal ["pizza"], cm.suggest("piz")
    assert_equal ["zombies"], cm.suggest("zo")
    assert_equal ["a", "aardvark"], cm.suggest("a").sort
    assert_equal ["aardvark"], cm.suggest("aa")
  end

  def test_inserts_medium_dataset
    cm.populate(medium_word_list)

    assert_equal medium_word_list.split("\n").count, cm.count
  end

  def test_suggests_off_of_medium_dataset
    cm.populate(medium_word_list)

    assert_equal ["williwaw", "wizardly"], cm.suggest("wi").sort
  end

  def test_selects_off_of_medium_dataset
    cm.populate(medium_word_list)
    cm.select("wi", "wizardly")
    cm.select("wi", "wizardly")

    assert_equal ["wizardly", "williwaw"], cm.suggest("wi")
  end

  def test_works_with_large_dataset
    skip
    cm.populate(large_word_list)

    assert_equal ["doggerel", "doggereler", "doggerelism", "doggerelist", "doggerelize", "doggerelizer"], cm.suggest("doggerel").sort

    cm.select("doggerel", "doggerelist")

    assert_equal "doggerelist", cm.suggest("doggerel").first
  end

  def test_select_substring_specific
    cm.insert('cool')
    cm.insert('cools')
    cm.insert('cooler')
    cm.insert('coolers')

    cm.select('co', 'cooler')
    cm.select('co', 'cooler')
    cm.select('co', 'cools')

    assert_equal "cooler", cm.suggest("co").first
    assert_equal "cools", cm.suggest("co")[1]
  end

  def test_substring_specific_from_spec
    cm.insert('pizza')
    cm.insert('pizzeria')
    cm.insert('pizzicato')
    cm.insert('pize')

    cm.select('piz', 'pizzeria')
    cm.select('pi', 'pizzicato')

    assert_equal 'pizzeria', cm.suggest('piz')[0]
    assert_equal 'pizzicato', cm.suggest('pi')[0]
  end

  def test_select_if_word_exists
    cm.insert('pizza')
    cm.insert('pizzeria')
    cm.insert('pizzicato')
    cm.insert('pize')
    expected = {"pizza" => 1}
    
    assert_equal expected, cm.select('pi', 'pizza')
    assert_nil cm.select('pi', 'watermelon')
  end

  def insert_words(words)
    cm.populate(words.join("\n"))
  end

  def medium_word_list
    File.read("test/data/medium.txt")
  end

  def large_word_list
    File.read("/usr/share/dict/words")
  end
end