defmodule GameTest do
  use ExUnit.Case
  alias Hangman.Game

  test "new_game returns structure" do    
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "all elements of game.letters are lowercase" do    
    game = Game.new_game()
    assert Enum.each(game.letters, fn(s) -> assert s == String.downcase(s) end)
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [ :won, :lost ] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert game = Game.make_move(game, "x")      
    end
  end

  test "first occurence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is a won game" do
    moves = [
      {"w", :good_guess},
      {"i", :good_guess},
      {"b", :good_guess},
      {"l", :good_guess},
      {"e", :won}      
    ]
    assert_moves(moves, Game.new_game("wibble"))
  end

  test "a bad guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do
    moves = [
      {"a", :bad_guess},
      {"b", :bad_guess},
      {"c", :bad_guess},
      {"d", :bad_guess},
      {"e", :bad_guess},
      {"f", :bad_guess},
      {"g", :lost}
    ]
    assert_moves(moves, Game.new_game("w"))
  end

  def assert_moves(moves, game) do
    Enum.reduce(moves, game, fn({guess, state}, new_game) ->
      new_game = Game.make_move(new_game, guess)
      assert new_game.game_state == state
      new_game
    end)
  end
end
