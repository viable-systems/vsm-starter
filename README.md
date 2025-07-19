# VSM Starter

[![Build Status](https://github.com/viable-systems/vsm-starter/workflows/CI/badge.svg)](https://github.com/viable-systems/vsm-starter/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Elixir Version](https://img.shields.io/badge/elixir-~%3E%201.15-purple)

A starter template for building Viable Systems Model (VSM) applications in Elixir. This template provides a foundation for implementing cybernetic systems based on Stafford Beer's VSM framework.

## Overview

The Viable Systems Model (VSM) is a model of the organizational structure of any autonomous system capable of producing itself. This starter template implements the core VSM components:

- **System 1**: Operations - The parts that do the work
- **System 2**: Coordination - Anti-oscillation and conflict resolution
- **System 3**: Control - Resource allocation and internal regulation
- **System 4**: Intelligence - Environmental scanning and future planning
- **System 5**: Policy - Identity, purpose, and ultimate authority

### Key Features

- 🎯 **Telemetry Integration**: Built-in observability with Telemetry
- 🔄 **Recursive Structure**: Support for nested viable systems
- 📊 **Variety Management**: Tools for managing complexity
- 🚨 **Algedonic Signals**: Alert channels for critical information
- 🔗 **Channel Architecture**: Command, resource, and audit channels
- 📈 **Performance Monitoring**: Real-time system metrics

## Installation

Add `vsm_starter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:vsm_starter, "~> 0.1.0"}
  ]
end
```

## Quick Start

### 1. Create a New VSM Application

```bash
mix new my_vsm_app --sup
cd my_vsm_app
```

### 2. Add VSM Starter Dependency

Update your `mix.exs`:

```elixir
defp deps do
  [
    {:vsm_starter, "~> 0.1.0"}
  ]
end
```

### 3. Configure Your Application

In `lib/my_vsm_app/application.ex`:

```elixir
defmodule MyVsmApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MyVsmApp.Telemetry,
      # Start System 1 operations
      {MyVsmApp.System1.Supervisor, name: MyVsmApp.System1.Supervisor},
      # Start System 2 coordination
      {MyVsmApp.System2, name: MyVsmApp.System2},
      # Start System 3 control
      {MyVsmApp.System3, name: MyVsmApp.System3},
      # Start System 4 intelligence
      {MyVsmApp.System4, name: MyVsmApp.System4},
      # Start System 5 policy
      {MyVsmApp.System5, name: MyVsmApp.System5}
    ]

    opts = [strategy: :one_for_one, name: MyVsmApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

### 4. Implement System Components

Example System 1 operation:

```elixir
defmodule MyVsmApp.System1.Operation do
  use GenServer
  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name])
  end

  @impl true
  def init(opts) do
    # Emit telemetry event
    :telemetry.execute(
      [:vsm, :system1, :operation, :start],
      %{count: 1},
      %{name: opts[:name]}
    )
    
    {:ok, %{name: opts[:name], state: :ready}}
  end

  def perform_operation(server, task) do
    GenServer.call(server, {:operate, task})
  end

  @impl true
  def handle_call({:operate, task}, _from, state) do
    start_time = System.monotonic_time()
    
    # Perform the operation
    result = execute_task(task)
    
    # Emit telemetry
    :telemetry.execute(
      [:vsm, :system1, :operation, :complete],
      %{duration: System.monotonic_time() - start_time},
      %{name: state.name, task: task}
    )
    
    {:reply, {:ok, result}, state}
  end

  defp execute_task(task) do
    # Your business logic here
    {:completed, task}
  end
end
```

## Architecture

### VSM Components

```
┌─────────────────────────────────────────────────┐
│                   System 5                      │
│                   (Policy)                      │
├─────────────────────┬───────────────────────────┤
│      System 4       │        System 3           │
│   (Intelligence)    │       (Control)           │
│                     │                           │
│  Environmental      │    ┌─────────────┐       │
│    Scanning         │    │  System 2   │       │
│                     │    │(Coordination)│       │
│                     │    └──────┬──────┘       │
│                     │           │               │
│                     │    ┌──────┴──────┐       │
│                     │    │  System 1   │       │
│                     │    │(Operations) │       │
└─────────────────────┴────┴─────────────┴───────┘
```

### Communication Channels

1. **Command Channel**: Downward instructions from management
2. **Resource Channel**: Upward flow of resources and capabilities
3. **Audit Channel**: System 3* direct monitoring capability
4. **Algedonic Channel**: Fast-track alerts for critical issues

## Telemetry Events

The VSM Starter emits the following telemetry events:

### System 1 Events
- `[:vsm, :system1, :operation, :start]` - Operation initiated
- `[:vsm, :system1, :operation, :complete]` - Operation completed
- `[:vsm, :system1, :operation, :error]` - Operation failed

### System 2 Events
- `[:vsm, :system2, :coordination, :conflict]` - Conflict detected
- `[:vsm, :system2, :coordination, :resolved]` - Conflict resolved

### System 3 Events
- `[:vsm, :system3, :resource, :allocated]` - Resource allocated
- `[:vsm, :system3, :audit, :performed]` - Audit performed

### System 4 Events
- `[:vsm, :system4, :environment, :scanned]` - Environmental scan
- `[:vsm, :system4, :model, :updated]` - Model updated

### System 5 Events
- `[:vsm, :system5, :policy, :set]` - Policy established
- `[:vsm, :system5, :identity, :changed]` - Identity modified

## Examples

### Basic VSM Implementation

```elixir
defmodule MyOrganization.VSM do
  use VsmStarter

  def start_link(opts) do
    VsmStarter.start_link(__MODULE__, opts)
  end
end

# Start the VSM
{:ok, vsm} = MyOrganization.VSM.start_link(
  name: MyOrganization.VSM,
  system_config: %{
    system1: %{operations: [:sales, :production, :delivery]},
    system2: %{coordination_interval: 5_000},
    system3: %{audit_probability: 0.1},
    system4: %{scan_interval: 30_000},
    system5: %{policy_review_interval: 86_400_000}
  }
)

# Use the VSM
VsmStarter.health_check(MyOrganization.VSM)
VsmStarter.variety_metrics(MyOrganization.VSM)
```

### Handling Algedonic Signals

```elixir
# Send algedonic signals through the VSM
VsmStarter.algedonic_signal(MyOrganization.VSM, :warning, %{
  source: :production,
  message: "Resource shortage detected",
  impact: :medium
})

VsmStarter.algedonic_signal(MyOrganization.VSM, :critical, %{
  source: :quality_control, 
  message: "Critical quality issue",
  impact: :high
})

VsmStarter.algedonic_signal(MyOrganization.VSM, :emergency, %{
  source: :safety,
  message: "Safety protocol breach",
  impact: :severe
})
```

## Configuration

Configure VSM Starter in your `config/config.exs`:

```elixir
config :vsm_starter,
  telemetry_prefix: [:my_org, :vsm],
  algedonic_threshold: :warning,
  audit_probability: 0.05,
  coordination_timeout: 5_000

# Configure telemetry poller
config :telemetry_poller, :default,
  period: 10_000,
  measurements: [
    {VsmStarter.Telemetry, :system_health, []},
    {VsmStarter.Telemetry, :variety_metrics, []}
  ]
```

## Testing

VSM Starter components can be tested using standard ExUnit:

```elixir
defmodule MyOrganization.VSMTest do
  use ExUnit.Case

  test "VSM health check returns operational status" do
    {:ok, _vsm} = MyOrganization.VSM.start_link(name: TestVSM)
    
    {:ok, health} = VsmStarter.health_check(TestVSM)
    
    assert health.overall == :healthy
    assert health.system1 == :operational
    assert health.system2 == :operational
    assert health.system3 == :operational
    assert health.system4 == :operational
    assert health.system5 == :operational
  end

  test "algedonic signals are handled correctly" do
    {:ok, _vsm} = MyOrganization.VSM.start_link(name: TestVSM)
    
    assert :ok = VsmStarter.algedonic_signal(TestVSM, :warning, %{
      source: :test,
      message: "Test warning"
    })
  end
end
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -am 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Stafford Beer for the Viable Systems Model
- The Elixir community for excellent tools and libraries
- Contributors to the VSM ecosystem

## Resources

- [Stafford Beer's VSM Overview](https://en.wikipedia.org/wiki/Viable_system_model)
- [Cybernetics and Management](https://www.kybernetik.ch/en/fs_methoden.html)
- [Telemetry Documentation](https://hexdocs.pm/telemetry)
- [Elixir Documentation](https://elixir-lang.org/docs.html)

## Support

- Source Code: [GitHub Repository](https://github.com/viable-systems/vsm-starter)
- Issues: [GitHub Issues](https://github.com/viable-systems/vsm-starter/issues)
- Documentation: Coming soon on Hex.pm after package publication