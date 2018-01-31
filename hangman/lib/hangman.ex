defmodule Hangman do
  alias Hangman.Game

  # reflects call to Hangman.Game
  defdelegate new_game(), to: Game
end
