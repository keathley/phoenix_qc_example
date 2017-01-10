defmodule PhoenixQcExample.EqcTest do
  use PhoenixQcExample.FeatureCase, async: true
  use ExCheck

  alias PhoenixQcExample.ClientStateMachine
  import PhoenixQcExample.EqcGenerators
  # 
  # property "users don't effect the other votes" do
  #   for_all commands in gen_commands() do
  #     commands
  #     |> Enum.map(fn {command, pid, args }->
  #       {:ok, expected, actual} = apply(ClientStateMachine, command, [pid, args])
  #       expected == actual
  #     end)
  #   end
  # end
end
