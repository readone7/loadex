defmodule Loadex do
  @moduledoc """
  Documentation for Loadex.
  """
  @doc """
  run/2

  ## Examples

      iex> Loadex.run()
      {:ok, msecs}

  """
  def run(n_workers, url) when n_workers > 0 do
    worker_func = fn -> Loadex.Worker.start(url) end
    1..n_workers
    |> Enum.map(fn _ -> Task.async(worker_func) end)
    |> Enum.map(&Task.await(&1, :infinity))
    |> parse_results
  end

  defp parse_results(results) do
    {successes, failures} = Enum.partition(results, fn result ->
      case result do
        {:ok, _} -> true
        _        -> false
      end
    end)

    total_workers = Enum.count(results)
    total_success = Enum.count(successes)
    total_failure = total_workers - total_success

    data = successes |> Enum.map(fn {:ok, time} -> time end)
    average_time = average(data)
    longest_time = Enum.max(data)
    shortest_time = Enum.min(data)

    IO.puts """
    Total workers       : #{total_workers}
    Successful requests : #{total_success}
    failed requests     : #{total_failure}
    Average (msecs)     : #{average_time}
    Longest (msecs)     : #{longest_time}
    Shortest (msecs)    : #{shortest_time}
    """
  end

  defp average(list) do
    sum = Enum.sum(list)
    if sum > 0 do
      sum/Enum.count(list)
    else
      0
    end
  end

end
