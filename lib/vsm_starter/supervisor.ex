defmodule VsmStarter.Supervisor do
  @moduledoc """
  Main supervisor for VSM components.

  This supervisor manages all five VSM systems and their communication channels.
  It ensures proper startup order and fault tolerance for the viable system.
  """

  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  @impl true
  def init(opts) do
    children = [
      # Communication channels (must start first)
      {VsmStarter.Channels.Supervisor, name: VsmStarter.Channels.Supervisor},

      # System 2 - Coordination (needs to be ready before System 1)
      {VsmStarter.System2, name: VsmStarter.System2},

      # System 1 - Operations
      {VsmStarter.System1.Supervisor, name: VsmStarter.System1.Supervisor},

      # System 3 - Control
      {VsmStarter.System3, name: VsmStarter.System3},

      # System 4 - Intelligence
      {VsmStarter.System4, name: VsmStarter.System4},

      # System 5 - Policy
      {VsmStarter.System5, name: VsmStarter.System5}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
