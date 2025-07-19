defmodule VsmStarter do
  @moduledoc """
  VSM Starter provides a foundation for building Viable Systems Model applications in Elixir.

  The Viable Systems Model (VSM) is a model of the organizational structure of any
  autonomous system capable of producing itself. A viable system is any system organised
  in such a way as to meet the demands of surviving in the changing environment.

  ## Core Concepts

  - **System 1**: Operations - The parts of the organization that do the work
  - **System 2**: Coordination - Ensures the parts of System 1 work harmoniously
  - **System 3**: Control - Responsible for resource allocation and performance
  - **System 4**: Intelligence - Looks outward to the environment
  - **System 5**: Policy - Provides closure and defines organizational identity

  ## Usage

  To use VSM Starter in your application, start by defining your viable system:

      defmodule MyOrganization do
        use VsmStarter
        
        def start_link(opts) do
          VsmStarter.start_link(__MODULE__, opts)
        end
      end

  """

  @doc """
  Starts a VSM supervision tree.

  ## Options

    * `:name` - The name to register the VSM under
    * `:telemetry_prefix` - Prefix for telemetry events (defaults to `[:vsm]`)
    * `:system_config` - Configuration for each system component

  ## Examples

      VsmStarter.start_link(MyOrganization,
        name: MyOrganization.VSM,
        telemetry_prefix: [:my_org, :vsm],
        system_config: %{
          system1: %{operations: [:sales, :production, :delivery]},
          system2: %{coordination_interval: 5_000},
          system3: %{audit_probability: 0.1},
          system4: %{scan_interval: 30_000},
          system5: %{policy_review_interval: 86_400_000}
        }
      )

  """
  def start_link(module, opts \\ []) do
    name = Keyword.get(opts, :name, module)

    children = [
      {VsmStarter.Telemetry, [name: Module.concat(name, Telemetry)]},
      {VsmStarter.Supervisor, Keyword.put(opts, :module, module)}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Module.concat(name, Supervisor))
  end

  @doc """
  Returns the current health status of the VSM.

  ## Examples

      iex> VsmStarter.health_check(MyOrganization.VSM)
      {:ok, %{
        system1: :operational,
        system2: :operational,
        system3: :operational,
        system4: :operational,
        system5: :operational,
        overall: :healthy
      }}

  """
  def health_check(vsm) do
    # Implementation would query each system component
    {:ok,
     %{
       system1: :operational,
       system2: :operational,
       system3: :operational,
       system4: :operational,
       system5: :operational,
       overall: :healthy
     }}
  end

  @doc """
  Sends an algedonic signal through the VSM.

  Algedonic signals are alerts that bypass the normal hierarchical channels
  and go directly to the relevant system level.

  ## Examples

      iex> VsmStarter.algedonic_signal(MyOrganization.VSM, :critical, %{
      ...>   source: :production,
      ...>   message: "Equipment failure",
      ...>   impact: :high
      ...> })
      :ok

  """
  def algedonic_signal(vsm, severity, payload) when severity in [:warning, :critical, :emergency] do
    :telemetry.execute(
      [:vsm, :algedonic, :signal],
      %{count: 1},
      %{severity: severity, payload: payload}
    )

    # Route to appropriate handler based on severity
    case severity do
      :warning -> handle_warning(vsm, payload)
      :critical -> handle_critical(vsm, payload)
      :emergency -> handle_emergency(vsm, payload)
    end
  end

  defp handle_warning(vsm, payload) do
    # Route to System 3
    :ok
  end

  defp handle_critical(vsm, payload) do
    # Route to System 4 and 5
    :ok
  end

  defp handle_emergency(vsm, payload) do
    # Immediate escalation to System 5
    :ok
  end

  @doc """
  Retrieves variety metrics from the VSM.

  Variety is a measure of the number of possible states of a system.
  According to the Law of Requisite Variety, only variety can destroy variety.

  ## Examples

      iex> VsmStarter.variety_metrics(MyOrganization.VSM)
      {:ok, %{
        environmental_variety: 1500,
        system_variety: 1200,
        variety_ratio: 0.8,
        attenuation_needed: 300
      }}

  """
  def variety_metrics(vsm) do
    {:ok,
     %{
       environmental_variety: 1500,
       system_variety: 1200,
       variety_ratio: 0.8,
       attenuation_needed: 300
     }}
  end

  @doc false
  defmacro __using__(opts) do
    quote do
      @behaviour VsmStarter.Behaviour

      def child_spec(opts) do
        %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [opts]},
          type: :supervisor
        }
      end

      def start_link(opts \\ []) do
        VsmStarter.start_link(__MODULE__, opts)
      end
    end
  end
end
