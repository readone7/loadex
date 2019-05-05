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
    |> Enum.map(&Task.await(&1))
  end

end
