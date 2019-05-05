defmodule Loadex.Worker do
  use Timex
  require Logger

  def start(url) do
    IO.puts "hello, #{url}"
  end

end
