defmodule VsmStarter.System2 do
  @moduledoc """
  System 2: Coordination

  Ensures that the various operational units (System 1) work harmoniously together.
  Provides anti-oscillation mechanisms and resolves conflicts between operational units.
  """

  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  @impl true
  def init(opts) do
    Logger.info("System 2 (Coordination) starting...")

    # Schedule periodic coordination checks
    schedule_coordination_check()

    {:ok,
     %{
       coordination_rules: opts[:rules] || [],
       conflict_count: 0,
       resolution_count: 0
     }}
  end

  @doc """
  Reports a potential conflict between operational units.
  """
  def report_conflict(coordinator \\ __MODULE__, conflict) do
    GenServer.cast(coordinator, {:report_conflict, conflict})
  end

  @impl true
  def handle_cast({:report_conflict, conflict}, state) do
    Logger.warning("System 2: Conflict detected - #{inspect(conflict)}")

    :telemetry.execute(
      [:vsm, :system2, :coordination, :conflict],
      %{count: 1},
      %{conflict: conflict}
    )

    # Apply coordination rules to resolve conflict
    case resolve_conflict(conflict, state.coordination_rules) do
      {:ok, resolution} ->
        :telemetry.execute(
          [:vsm, :system2, :coordination, :resolved],
          %{count: 1},
          %{resolution: resolution}
        )

        {:noreply, %{state | conflict_count: state.conflict_count + 1, resolution_count: state.resolution_count + 1}}

      {:error, _reason} ->
        # Escalate to System 3 if cannot resolve
        escalate_to_system3(conflict)
        {:noreply, %{state | conflict_count: state.conflict_count + 1}}
    end
  end

  @impl true
  def handle_info(:coordination_check, state) do
    # Periodic coordination check
    check_system_harmony()
    schedule_coordination_check()
    {:noreply, state}
  end

  defp resolve_conflict(conflict, rules) do
    # Apply coordination rules
    # This is a simplified example
    {:ok, %{action: :synchronized, conflict: conflict}}
  end

  defp escalate_to_system3(conflict) do
    Logger.info("System 2: Escalating conflict to System 3 - #{inspect(conflict)}")
    # Send to System 3
  end

  defp check_system_harmony do
    # Check for potential oscillations or conflicts
    Logger.debug("System 2: Performing coordination check")
  end

  defp schedule_coordination_check do
    Process.send_after(self(), :coordination_check, 5_000)
  end
end
