
require 'set'

class WordChainer

	def initialize(dictionary_file)
		@dictionary = File.readlines("dictionary.txt").map! { |word| word.chomp }
		@dictionary = Set.new(@dictionary)
	end

	def adjacent_words(word)
		adjacent_words = []

		word.each_char.with_index do |original_letter, index|
			("a".."z").each do |new_letter|
				next if new_letter == original_letter
				new_word = word.dup
				new_word[index] = new_letter

				adjacent_words << new_word if @dictionary.include?(new_word)
			end
		end

		adjacent_words
	end

	def run(source, target)
		@current_words = [source]
		@all_seen_words = {source => nil}

		until @current_words.empty? || @all_seen_words.include?(target)
      		explore_current_words until @current_words.empty?
    	end

    	build_path(target)

	end

	def explore_current_words
		new_current_words = []
			
		@current_words.each do |word|
			adjacent_words = adjacent_words(word)
			
			adjacent_words.each do |adj_word|
				next if @all_seen_words.include?(adj_word)

				new_current_words << adj_word
				@all_seen_words[adj_word] = word
			end
		end

		@current_words = new_current_words

	end

	def build_path(target)
		path = []
		last_word = target
		until last_word == nil
			path << last_word
			last_word = @all_seen_words[last_word]
		end

		path.reverse 
	end
end

