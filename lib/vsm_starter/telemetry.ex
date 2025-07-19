defmodule VsmStarter.Telemetry do
  @moduledoc """
  Telemetry supervision and event handling for VSM applications.

  This module sets up telemetry reporters and handles metric collection
  for all VSM components. It provides built-in instrumentation for:

  - System performance metrics
  - Variety measurements
  - Channel communication patterns
  - Algedonic signal frequency
  - Resource allocation efficiency
  """

  use Supervisor
  import Telemetry.Metrics

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      # Telemetry poller for periodic measurements
      {:telemetry_poller, measurements: periodic_measurements(), period: 10_000}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  Returns the list of telemetry metrics for VSM monitoring.
  """
  def metrics do
    [
      # System 1 - Operations metrics
      counter("vsm.system1.operation.start.count"),
      summary("vsm.system1.operation.complete.duration",
        unit: {:native, :millisecond},
        tags: [:name, :task]
      ),
      counter("vsm.system1.operation.error.count"),

      # System 2 - Coordination metrics
      counter("vsm.system2.coordination.conflict.count"),
      counter("vsm.system2.coordination.resolved.count"),
      summary("vsm.system2.coordination.resolution.duration",
        unit: {:native, :millisecond}
      ),

      # System 3 - Control metrics
      counter("vsm.system3.resource.allocated.count"),
      summary("vsm.system3.resource.allocated.amount"),
      counter("vsm.system3.audit.performed.count"),

      # System 4 - Intelligence metrics
      counter("vsm.system4.environment.scanned.count"),
      summary("vsm.system4.environment.scanned.duration",
        unit: {:native, :millisecond}
      ),
      counter("vsm.system4.model.updated.count"),

      # System 5 - Policy metrics
      counter("vsm.system5.policy.set.count"),
      counter("vsm.system5.identity.changed.count"),

      # Channel metrics
      counter("vsm.channel.command.sent.count"),
      counter("vsm.channel.resource.sent.count"),
      counter("vsm.channel.audit.sent.count"),
      counter("vsm.channel.algedonic.sent.count"),

      # Variety metrics
      last_value("vsm.variety.environmental"),
      last_value("vsm.variety.system"),
      last_value("vsm.variety.ratio"),

      # Overall health
      last_value("vsm.health.score")
    ]
  end

  @doc """
  Attaches default telemetry handlers for VSM events.
  """
  def attach_default_handlers do
    events = [
      [:vsm, :system1, :operation, :start],
      [:vsm, :system1, :operation, :complete],
      [:vsm, :system1, :operation, :error],
      [:vsm, :system2, :coordination, :conflict],
      [:vsm, :system2, :coordination, :resolved],
      [:vsm, :system3, :resource, :allocated],
      [:vsm, :system3, :audit, :performed],
      [:vsm, :system4, :environment, :scanned],
      [:vsm, :system4, :model, :updated],
      [:vsm, :system5, :policy, :set],
      [:vsm, :system5, :identity, :changed],
      [:vsm, :algedonic, :signal]
    ]

    :telemetry.attach_many(
      "vsm-default-handler",
      events,
      &handle_event/4,
      nil
    )
  end

  @doc """
  Default telemetry event handler that logs VSM events.
  """
  def handle_event(event, measurements, metadata, _config) do
    require Logger

    event_name = event |> Enum.join(".")

    Logger.debug(
      "[VSM Telemetry] #{event_name} - " <>
        "measurements: #{inspect(measurements)}, " <>
        "metadata: #{inspect(metadata)}"
    )
  end

  @doc """
  Returns system health metrics.

  This is called periodically by the telemetry poller.
  """
  def system_health do
    # In a real implementation, this would check actual system status
    [
      {:vsm_health_score, 95},
      {:vsm_variety_environmental, :rand.uniform(2000)},
      {:vsm_variety_system, :rand.uniform(1800)},
      {:vsm_active_operations, :rand.uniform(50)}
    ]
  end

  @doc """
  Returns variety-related metrics.

  Variety is a core concept in cybernetics and VSM.
  """
  def variety_metrics do
    env_variety = :rand.uniform(2000)
    sys_variety = :rand.uniform(1800)

    [
      {:vsm_variety_environmental, env_variety},
      {:vsm_variety_system, sys_variety},
      {:vsm_variety_ratio, sys_variety / env_variety}
    ]
  end

  defp periodic_measurements do
    [
      # Add measurements from this module
      {__MODULE__, :system_health, []},
      {__MODULE__, :variety_metrics, []},

      # Memory metrics
      :memory,

      # Custom VM metrics
      {:process_info,
       [
         event: [:vsm, :vm, :metrics],
         name: VsmStarter.Supervisor,
         keys: [:message_queue_len, :memory]
       ]}
    ]
  end

  @doc """
  Emits a telemetry event for VSM operations.

  ## Examples

      iex> VsmStarter.Telemetry.emit_event([:system1, :operation, :start], %{count: 1}, %{operation: :process_order})
      :ok
  """
  def emit_event(event_suffix, measurements, metadata \\ %{}) do
    event = [:vsm] ++ event_suffix
    :telemetry.execute(event, measurements, metadata)
  end
end
