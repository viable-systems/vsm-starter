defmodule VsmStarter.System1 do
  @moduledoc """
  System 1: Operations

  The primary activities of the organization. These are the parts that do the actual work
  and produce the organization's products or services. Each operational unit should be
  a viable system in its own right.
  """
end

defmodule VsmStarter.System1.Supervisor do
  @moduledoc """
  Supervisor for System 1 operational units.
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      # Operational units would be started here
      # Each unit is itself a viable system
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
