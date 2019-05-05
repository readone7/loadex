defmodule Loadex.Worker do
  use Timex
  require Logger

  def start(url) do
    {timestamp, response} = Duration.measure(fn -> HTTPoison.get(url) end)
    handle_response({Duration.to_milliseconds(timestamp), response})
  end

  defp handle_response({msecs, {:ok, %HTTPoison.Response{status_code: code}}}) when code >= 200 and code <= 304 do
    Logger.info "worker completed in #{msecs}"
    {:ok, msecs}
  end

  defp handle_response({_msecs, {:error, reason}}) do
    Logger.info "worker errordue to #{inspect reason}"
    {:error, reason}
  end

  defp handle_response({_msecs, _}) do
    Logger.info "worker errored out"
    {:error, :unknown}
  end

end
