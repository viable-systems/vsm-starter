# Test script to verify VSM Starter functionality

# Test 1: Check module availability
IO.puts("Test 1: Checking module availability...")
IO.inspect(Code.ensure_loaded?(VsmStarter))
IO.inspect(Code.ensure_loaded?(VsmStarter.Telemetry))

# Test 2: Use basic functions
IO.puts("\nTest 2: Testing basic functions...")
{:ok, health} = VsmStarter.health_check(:test_vsm)
IO.inspect(health, label: "Health check")

{:ok, metrics} = VsmStarter.variety_metrics(:test_vsm)
IO.inspect(metrics, label: "Variety metrics")

# Test 3: Test algedonic signals
IO.puts("\nTest 3: Testing algedonic signals...")
:ok = VsmStarter.algedonic_signal(:test_vsm, :warning, %{message: "Test warning"})
IO.puts("Warning signal sent successfully")

:ok = VsmStarter.algedonic_signal(:test_vsm, :critical, %{message: "Test critical"})
IO.puts("Critical signal sent successfully")

# Test 4: Start a minimal VSM system
IO.puts("\nTest 4: Starting VSM components...")

# Define a test VSM module
defmodule TestVSM do
  use VsmStarter
end

# Start individual components
{:ok, telemetry_pid} = VsmStarter.Telemetry.start_link([])
IO.puts("✓ Telemetry started: #{inspect(telemetry_pid)}")

{:ok, channels_pid} = VsmStarter.Channels.Supervisor.start_link([])
IO.puts("✓ Channels started: #{inspect(channels_pid)}")

{:ok, sys2_pid} = VsmStarter.System2.start_link([])
IO.puts("✓ System 2 started: #{inspect(sys2_pid)}")

{:ok, sys1_pid} = VsmStarter.System1.Supervisor.start_link([])
IO.puts("✓ System 1 started: #{inspect(sys1_pid)}")

{:ok, sys3_pid} = VsmStarter.System3.start_link([])
IO.puts("✓ System 3 started: #{inspect(sys3_pid)}")

{:ok, sys4_pid} = VsmStarter.System4.start_link([])
IO.puts("✓ System 4 started: #{inspect(sys4_pid)}")

{:ok, sys5_pid} = VsmStarter.System5.start_link([])
IO.puts("✓ System 5 started: #{inspect(sys5_pid)}")

# Test 5: Interact with running systems
IO.puts("\nTest 5: Testing system interactions...")

# System 3: Allocate resources
:ok = VsmStarter.System3.allocate_resources(:unit1, 100)
IO.puts("✓ Resources allocated to unit1")

# System 3: Perform audit
{:ok, audit_result} = VsmStarter.System3.audit(:unit1)
IO.inspect(audit_result, label: "Audit result")

# System 4: Environmental scan
{:ok, scan_results} = VsmStarter.System4.scan_environment()
IO.inspect(scan_results, label: "Environmental scan")

# System 5: Set policy
:ok = VsmStarter.System5.set_policy(:sustainability, :high_priority)
IO.puts("✓ Policy set successfully")

# System 2: Report conflict
VsmStarter.System2.report_conflict(%{units: [:unit1, :unit2], resource: :budget})
IO.puts("✓ Conflict reported to System 2")

IO.puts("\n🎉 All tests passed! VSM Starter is working correctly.")

# Keep the processes alive for a moment to see logs
:timer.sleep(1000)

# Stop all processes
IO.puts("\nStopping all processes...")
GenServer.stop(sys5_pid)
GenServer.stop(sys4_pid)
GenServer.stop(sys3_pid)
GenServer.stop(sys2_pid)
Supervisor.stop(sys1_pid)
Supervisor.stop(channels_pid)
Supervisor.stop(telemetry_pid)

IO.puts("✓ All processes stopped cleanly")