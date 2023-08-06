class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_reader :word, :guesses, :wrong_guesses
  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError, "Invalid guess: empty guess is not allowed." if letter.nil?
    raise ArgumentError, "Invalid guess: not a letter." unless letter.match?(/[a-z]/i)

    letter.downcase!
    
    return false if @guesses.include?(letter) || @wrong_guesses.include?(letter)

    if @word.include?(letter)
      @guesses << letter
    else
      @wrong_guesses << letter
    end

    true
  end

  def word_with_guesses
    @word.chars.map { |ch| @guesses.include?(ch) ? ch : '-' }.join
  end

  def check_win_or_lose
    return :win if word_with_guesses == @word
    return :lose if @wrong_guesses.size >= 7

    :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
