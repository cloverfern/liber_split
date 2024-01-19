defmodule LiberSplit do
  @moduledoc """
  Documentation for `LiberSplit`.
  """

  @doc """
  `split_evenly` Takes in an amount and a list of identifiers to split the amount evenly between.
  it returns a map of n evenly distributed amounts. This is likely to be replaced by a smarter
  method later.

  ## Things to consider
  - Is returning a list a concern of this module? In other words, is this module responsible for
  assigning amounts to people? It feels to me at first glance that it should. But keep an open
  mind.
  ## Examples
  iex> LiberSplit.split_evenly(100.0, [0, 1])
  %{0=>50.0, 1=>50.0}

  iex> LiberSplit.split_evenly(100.0, [0, 0, 1, 2, 3, 4])
  %{0=>20.0, 1=>20.0, 2=>20.0, 3=>20.0, 4=>20.0}
  """
  @spec split_evenly(float, list(integer)) :: %{integer=>float}
  def split_evenly(amount, people) do
    people = Enum.dedup(people)
    split = amount / length(people)
    Enum.reduce(people, %{}, fn elem, acc -> Map.put(acc, elem, split) end)
  end

end
