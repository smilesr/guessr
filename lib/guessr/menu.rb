module Guessr
  class Menu
    def initialize
      @player = nil
      @game = nil
      @playerall = nil
    end

    def choose_player
      puts "Welcome Player 1!"
      puts "Please enter your name: "
      result = gets.chomp
      until result =~ /^\w+$/
        puts "Please enter a name you doofus: "
        result = gets.chomp
      end
      @player = Player.find_or_create_by(name: result)
      # puts "Please choose a player: "
      # Player.find_each do |p|
      #   puts "#{p.id} -> #{p.name}"
      # end
      # result = gets.chomp
      # until result =~ /^\d+$/
      #   puts "Please choose one of the listed ids."
      #   result = gets.chomp
      # end
      # @player = Player.find(result.to_i)
    end

    def display_scoreboard
      puts "Would you like to see current scoreboard (1) yes or (2) no:"
      result = gets.chomp
      until result =~ /^[12]$/
        puts "please type either (1) for yes or (2) for no:"
        result = gets.chomp
      end
      scoreboard
    end

    def scoreboard
      Player.all.order(score: :desc).each do |x|
        puts "#{x.name} ... #{x.score}"
      end
      # @playerall = Player.all
      # playerx = @playerall.to_a
      # puts "#{playerx[1]}"
      # (1..3).each |x|
      #   puts @playerall[x]
      # end

   #binding.pry
    end
  #    puts " this is the record: #{@playerall}" 


    def choose_game
      puts "Start a new game (1) or resume an existing game (2)?"
      result = gets.chomp
      until result =~ /^[12]$/
        puts "Please choose new game (1) or existing game (2). Doofus."
        result = gets.chomp
      end
      if result.to_i == 1
        @game = @player.games.create(answer: rand(100),
                                     guess_count: 0)
      else
        @player.games.where(finished: false).find_each do |game|
          puts "#{game.id} => Last Guess: #{game.last_guess}, Guess Count: #{game.guess_count}"
        end
        puts "Please choose one of the numbered games: "
        result = gets.chomp
        until result =~ /^\d+$/
          puts "I said pick a *numbered* game dummy."
          result = gets.chomp
        end
        @game = Game.find(result)
      end
    end

    def run
      welcome
      choose_player
      display_scoreboard
      while play_again?
        choose_game
        @game.play
      end
      puts "Thanks for playing!"
    end

    def play_again?
      puts "Would you like to play again? (y or n)"
      result = gets.chomp
      until result =~ /^[yn]$/i
        puts "You have to choose yes (y) or no (n)."
        result = gets.chomp
      end
      result.downcase == 'y'
    end

    def welcome
      puts "\n\n"
      puts "Welcome to the guessing game!"
      puts "At any time, you may exit the game by pressing (q) to Quit."
      puts "\n\n"
    end
  end
end
