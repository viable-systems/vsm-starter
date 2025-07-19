defmodule VsmStarter.System4 do
  @moduledoc """
  System 4: Intelligence

  The forward-looking component of the organization. Scans the environment,
  identifies opportunities and threats, and develops models of the future.
  Works with System 3 to ensure the organization adapts to change.
  """

  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  @impl true
  def init(opts) do
    Logger.info("System 4 (Intelligence) starting...")

    # Schedule periodic environmental scanning
    schedule_environmental_scan(opts[:scan_interval] || 30_000)

    {:ok,
     %{
       environmental_data: %{},
       future_models: [],
       opportunities: [],
       threats: []
     }}
  end

  @doc """
  Performs an environmental scan.
  """
  def scan_environment(intelligence \\ __MODULE__) do
    GenServer.call(intelligence, :scan_environment)
  end

  @doc """
  Updates the future model based on new data.
  """
  def update_model(intelligence \\ __MODULE__, model_data) do
    GenServer.cast(intelligence, {:update_model, model_data})
  end

  @impl true
  def handle_call(:scan_environment, _from, state) do
    start_time = System.monotonic_time()

    # Simulate environmental scanning
    scan_results = %{
      market_trends: analyze_market(),
      competitor_activity: analyze_competitors(),
      regulatory_changes: analyze_regulations(),
      technology_shifts: analyze_technology()
    }

    :telemetry.execute(
      [:vsm, :system4, :environment, :scanned],
      %{duration: System.monotonic_time() - start_time},
      %{results: scan_results}
    )

    {:reply, {:ok, scan_results}, %{state | environmental_data: scan_results}}
  end

  @impl true
  def handle_cast({:update_model, model_data}, state) do
    Logger.info("System 4: Updating future model with new data")

    :telemetry.execute(
      [:vsm, :system4, :model, :updated],
      %{count: 1},
      %{model: model_data}
    )

    {:noreply, %{state | future_models: [model_data | state.future_models]}}
  end

  @impl true
  def handle_info(:environmental_scan, state) do
    Logger.debug("System 4: Performing scheduled environmental scan")
    scan_environment()
    schedule_environmental_scan()
    {:noreply, state}
  end

  defp schedule_environmental_scan(interval \\ 30_000) do
    Process.send_after(self(), :environmental_scan, interval)
  end

  defp analyze_market do
    %{growth_rate: 0.05, volatility: :moderate}
  end

  defp analyze_competitors do
    %{new_entrants: 2, market_share_changes: %{}}
  end

  defp analyze_regulations do
    %{new_regulations: [], compliance_updates: []}
  end

  defp analyze_technology do
    %{emerging_tech: [:ai, :blockchain], adoption_rates: %{}}
  end
end
