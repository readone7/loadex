defmodule Loadex do
  use Application

  def start(_type, _args) do
    Loadex.Supervisor.start_link(:ok)
  end
end
