defmodule VsmStarter.System3 do
  @moduledoc """
  System 3: Control

  Responsible for the internal stability of the organization. Allocates resources
  to System 1 units, monitors performance, and ensures adherence to policies.
  Includes System 3* (audit) function for direct monitoring.
  """

  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  @impl true
  def init(_opts) do
    Logger.info("System 3 (Control) starting...")

    {:ok,
     %{
       resource_allocations: %{},
       performance_metrics: %{},
       audit_results: []
     }}
  end

  @doc """
  Allocates resources to a System 1 unit.
  """
  def allocate_resources(controller \\ __MODULE__, unit, resources) do
    GenServer.call(controller, {:allocate_resources, unit, resources})
  end

  @doc """
  Performs a System 3* audit on a specific unit.
  """
  def audit(controller \\ __MODULE__, unit) do
    GenServer.call(controller, {:audit, unit})
  end

  @impl true
  def handle_call({:allocate_resources, unit, resources}, _from, state) do
    :telemetry.execute(
      [:vsm, :system3, :resource, :allocated],
      %{amount: resources},
      %{unit: unit}
    )

    new_allocations = Map.put(state.resource_allocations, unit, resources)
    {:reply, :ok, %{state | resource_allocations: new_allocations}}
  end

  @impl true
  def handle_call({:audit, unit}, _from, state) do
    Logger.info("System 3*: Performing audit on #{unit}")

    :telemetry.execute(
      [:vsm, :system3, :audit, :performed],
      %{count: 1},
      %{unit: unit}
    )

    audit_result = %{unit: unit, timestamp: System.system_time(), status: :passed}
    {:reply, {:ok, audit_result}, %{state | audit_results: [audit_result | state.audit_results]}}
  end
end
