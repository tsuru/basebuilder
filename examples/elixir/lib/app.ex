defmodule App do
  use Application
  @moduledoc "Entry point module"
  
  def start(_type, _args) do
    run && App.Supervisor.start_link
  end

  def run do
    routes = [ {"/", App.PageHandler, []} ]
    dispatch = :cowboy_router.compile([{:_, routes}])
    opts = [port: :os.getenv("PORT") || 5000]
    env = [dispatch: dispatch]

    {:ok, _pid} = :cowboy.start_http(:http, 100, opts, [env: env])
  end
end
