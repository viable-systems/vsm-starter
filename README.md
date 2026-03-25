# vsm_starter

Elixir library that provides a supervision tree template for building applications based on Stafford Beer's Viable Systems Model. Defines GenServer stubs for all 5 VSM subsystems, communication channels, and telemetry integration.

## Status

- Version: 0.1.0
- Published to Hex under the `viable_systems` organization
- 1 test file; coverage unknown
- CI via GitHub Actions

## What it does

Provides a `use VsmStarter` macro that sets up a supervision tree with GenServer processes for Systems 1 through 5, plus channel and telemetry infrastructure. Applications call `VsmStarter.start_link/2` to boot the tree.

## Modules

| Module | Purpose |
|--------|---------|
| `VsmStarter` | Main API: start_link, health_check, algedonic_signal, variety_metrics |
| `VsmStarter.Behaviour` | Behaviour definition for VSM implementations |
| `VsmStarter.Supervisor` | Top-level supervisor for the 5 systems |
| `VsmStarter.System1` | Operations GenServer |
| `VsmStarter.System2` | Coordination GenServer |
| `VsmStarter.System3` | Control GenServer |
| `VsmStarter.System4` | Intelligence GenServer |
| `VsmStarter.System5` | Policy GenServer |
| `VsmStarter.Channels` | Command, resource, and algedonic channels |
| `VsmStarter.Telemetry` | Telemetry event definitions and poller setup |

## API

```elixir
# Define a viable system
defmodule MySystem do
  use VsmStarter
end

# Start it
{:ok, _} = MySystem.start_link(
  name: MySystem.VSM,
  system_config: %{
    system1: %{operations: [:sales, :production]},
    system2: %{coordination_interval: 5_000},
    system3: %{audit_probability: 0.1},
    system4: %{scan_interval: 30_000},
    system5: %{policy_review_interval: 86_400_000}
  }
)

# Health check
{:ok, health} = VsmStarter.health_check(MySystem.VSM)
# => %{system1: :operational, ..., overall: :healthy}

# Send algedonic signal (bypass normal channels)
VsmStarter.algedonic_signal(MySystem.VSM, :critical, %{
  source: :production,
  message: "Equipment failure"
})

# Get variety metrics
{:ok, metrics} = VsmStarter.variety_metrics(MySystem.VSM)
# => %{environmental_variety: 1500, system_variety: 1200, variety_ratio: 0.8, ...}
```

## Telemetry events emitted

| Event | When |
|-------|------|
| `[:vsm, :system1, :operation, :start]` | Operation initiated |
| `[:vsm, :system1, :operation, :complete]` | Operation completed |
| `[:vsm, :system1, :operation, :error]` | Operation failed |
| `[:vsm, :system2, :coordination, :conflict]` | Conflict detected |
| `[:vsm, :system2, :coordination, :resolved]` | Conflict resolved |
| `[:vsm, :system3, :resource, :allocated]` | Resource allocated |
| `[:vsm, :system3, :audit, :performed]` | Audit performed |
| `[:vsm, :system4, :environment, :scanned]` | Environmental scan |
| `[:vsm, :system4, :model, :updated]` | Model updated |
| `[:vsm, :system5, :policy, :set]` | Policy established |
| `[:vsm, :system5, :identity, :changed]` | Identity modified |
| `[:vsm, :algedonic, :signal]` | Algedonic signal sent |

## Installation

```elixir
def deps do
  [{:vsm_starter, "~> 0.1.0", organization: "viable_systems"}]
end
```

## Limitations

- `health_check/1` and `variety_metrics/1` return hardcoded values; they do not query actual system state
- Algedonic signal handlers (`handle_warning`, `handle_critical`, `handle_emergency`) are no-ops that return `:ok`
- The `use VsmStarter` macro defines `start_link/1` and `child_spec/1` but individual system modules may need manual wiring
- No generator (`mix vsm.new`) despite being called a "starter template"
- Only depends on telemetry, jason, and decimal; no dependency on vsm_core

## License

MIT
