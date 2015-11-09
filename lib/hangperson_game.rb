class HangpersonGame
  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  
  def guess(guess)
    letter = guess.to_s.downcase[0]
    raise ArgumentError, 'guess cannot be either: empty, non-letter or nil.' unless letter =~ /[a-z]/i
    
    # return false if already guessed
    return false if self.guesses.include?(letter) || self.wrong_guesses.include?(letter)
    
    valid = self.word.include?(letter)
    if valid
      self.guesses << letter
    else
      self.wrong_guesses << letter
    end
  end
  
  def check_win_or_lose
    return :lose unless self.wrong_guesses.size < 7
    self.word_with_guesses.eql?(self.word) ? :win : :play
  end
  
  def word_with_guesses
    return self.word.gsub(/./, '-') if self.guesses.empty?
    
    gmatch_rgx = /[^#{ self.guesses }]/i
    self.word.gsub(gmatch_rgx, '-')
  end

  # Get a word from remote "random word" service
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end
end
