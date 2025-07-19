defmodule VsmStarter.Behaviour do
  @moduledoc """
  Behaviour definition for VSM implementations.

  Modules implementing this behaviour should define the structure
  and configuration of their viable system.
  """

  @callback operations() :: [{atom(), module()}]
  @callback coordination_rules() :: [any()]
  @callback control_config() :: map()
  @callback intelligence_config() :: map()
  @callback policy_config() :: map()

  @optional_callbacks operations: 0,
                      coordination_rules: 0,
                      control_config: 0,
                      intelligence_config: 0,
                      policy_config: 0
end
