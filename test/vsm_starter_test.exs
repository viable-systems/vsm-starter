defmodule VsmStarterTest do
  use ExUnit.Case
  doctest VsmStarter

  describe "health_check/1" do
    test "returns healthy status for all systems" do
      assert {:ok, status} = VsmStarter.health_check(TestVSM)

      assert status.system1 == :operational
      assert status.system2 == :operational
      assert status.system3 == :operational
      assert status.system4 == :operational
      assert status.system5 == :operational
      assert status.overall == :healthy
    end
  end

  describe "algedonic_signal/3" do
    test "accepts warning severity signals" do
      assert :ok = VsmStarter.algedonic_signal(TestVSM, :warning, %{message: "test"})
    end

    test "accepts critical severity signals" do
      assert :ok = VsmStarter.algedonic_signal(TestVSM, :critical, %{message: "test"})
    end

    test "accepts emergency severity signals" do
      assert :ok = VsmStarter.algedonic_signal(TestVSM, :emergency, %{message: "test"})
    end
  end

  describe "variety_metrics/1" do
    test "returns variety measurements" do
      assert {:ok, metrics} = VsmStarter.variety_metrics(TestVSM)

      assert is_number(metrics.environmental_variety)
      assert is_number(metrics.system_variety)
      assert is_number(metrics.variety_ratio)
      assert is_number(metrics.attenuation_needed)
    end
  end
end
