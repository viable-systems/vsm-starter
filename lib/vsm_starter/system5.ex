defmodule VsmStarter.System5 do
  @moduledoc """
  System 5: Policy

  Provides closure to the whole system. Defines and maintains organizational
  identity, purpose, and values. Makes ultimate decisions and resolves
  conflicts between System 3 (present) and System 4 (future).
  """

  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  @impl true
  def init(_opts) do
    Logger.info("System 5 (Policy) starting...")

    {:ok,
     %{
       identity: "Viable System",
       purpose: "To maintain viability in a changing environment",
       values: [:adaptability, :resilience, :effectiveness],
       policies: %{},
       decisions: []
     }}
  end

  @doc """
  Sets organizational identity.
  """
  def set_identity(policy \\ __MODULE__, identity) do
    GenServer.call(policy, {:set_identity, identity})
  end

  @doc """
  Establishes a new policy.
  """
  def set_policy(policy \\ __MODULE__, name, value) do
    GenServer.call(policy, {:set_policy, name, value})
  end

  @doc """
  Makes a strategic decision when System 3 and 4 conflict.
  """
  def make_decision(policy \\ __MODULE__, conflict) do
    GenServer.call(policy, {:make_decision, conflict})
  end

  @impl true
  def handle_call({:set_identity, identity}, _from, state) do
    Logger.info("System 5: Setting organizational identity to: #{identity}")

    :telemetry.execute(
      [:vsm, :system5, :identity, :changed],
      %{count: 1},
      %{identity: identity}
    )

    {:reply, :ok, %{state | identity: identity}}
  end

  @impl true
  def handle_call({:set_policy, name, value}, _from, state) do
    Logger.info("System 5: Establishing policy #{name}")

    :telemetry.execute(
      [:vsm, :system5, :policy, :set],
      %{count: 1},
      %{policy: name, value: value}
    )

    new_policies = Map.put(state.policies, name, value)
    {:reply, :ok, %{state | policies: new_policies}}
  end

  @impl true
  def handle_call({:make_decision, conflict}, _from, state) do
    Logger.info("System 5: Making strategic decision on conflict")

    # Decision logic balancing present stability (System 3) and future viability (System 4)
    decision = resolve_conflict(conflict, state.values)

    {:reply, {:ok, decision}, %{state | decisions: [decision | state.decisions]}}
  end

  defp resolve_conflict(conflict, values) do
    %{
      conflict: conflict,
      resolution: :balance_present_and_future,
      rationale: "Decision based on organizational values: #{inspect(values)}",
      timestamp: System.system_time()
    }
  end
end
