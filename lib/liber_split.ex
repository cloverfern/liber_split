defmodule LiberSplit do
  @moduledoc """
  Documentation for `LiberSplit`.
  """

  @type error :: :einvsplit
  @type split :: %{pos_integer=>float}

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
  @spec split_evenly(float, list(pos_integer)) :: split
  def split_evenly(amount, people) do
    split_calc = &(amount / length(&1))
    split = people |> Enum.dedup() |> split_calc.()
    Enum.reduce(people, %{}, fn id, split_by_id -> Map.put(split_by_id, id, split) end)
  end

  @doc"""
  `split_percentage` takes in an amount and a map of identifiers to split percentages. It returns
  a a tuple with a status code and map of identifiers to the corresponding amount. Sum of
  percentages mustn't go over 100 percent. But it can be below 100 percent.

  ## Examples
  iex> LiberSplit.split_percentage(100.0, %{1=>0.4})
  {:ok, %{1=>40.0}}

  iex> LiberSplit.split_percentage(100.0, %{1=>1.1})
  {:error, %{}}
  """
  @spec split_percentage(float, split) :: { :ok , split }| { :error, error }
  def split_percentage(amount, percentage_by_id) do
    total = Enum.reduce(percentage_by_id, 0, fn {_, percentage}, total -> total + percentage end)
    accept_split_percentage(total, percentage_by_id, amount)
  end

  defp accept_split_percentage(total, _percentage_by_id, _amount)
  when total > 1 do
    {:error, %{}}
  end

  defp accept_split_percentage(total, percentage_by_id, amount)
  when total <= 1 do
    {:ok, Map.new(percentage_by_id, fn {id, percentage} -> {id, amount*percentage} end)}
  end

end
