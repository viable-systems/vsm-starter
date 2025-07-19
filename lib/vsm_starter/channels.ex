defmodule VsmStarter.Channels do
  @moduledoc """
  Communication channels for the VSM.

  The VSM defines several communication channels:
  - Command Channel: Downward communication of instructions
  - Resource Channel: Upward negotiation of resources
  - Audit Channel: System 3* direct monitoring
  - Algedonic Channel: Fast alerts that bypass hierarchy
  """
end

defmodule VsmStarter.Channels.Supervisor do
  @moduledoc """
  Supervisor for VSM communication channels.
  """
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      {VsmStarter.Channels.Command, name: VsmStarter.Channels.Command},
      {VsmStarter.Channels.Resource, name: VsmStarter.Channels.Resource},
      {VsmStarter.Channels.Audit, name: VsmStarter.Channels.Audit},
      {VsmStarter.Channels.Algedonic, name: VsmStarter.Channels.Algedonic}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

defmodule VsmStarter.Channels.Command do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  def init(_opts), do: {:ok, %{}}
end

defmodule VsmStarter.Channels.Resource do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  def init(_opts), do: {:ok, %{}}
end

defmodule VsmStarter.Channels.Audit do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  def init(_opts), do: {:ok, %{}}
end

defmodule VsmStarter.Channels.Algedonic do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  def init(_opts), do: {:ok, %{}}
end
