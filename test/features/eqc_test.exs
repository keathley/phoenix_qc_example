defmodule PhoenixQcExample.EqcTest do
  use PhoenixQcExample.FeatureCase, async: true
  use EQC.ExUnit

  alias PhoenixQcExample.ClientStateMachine

  # property "users get the correct votes" do
    # {:ok, session} = Wallaby.start_session
    # {:ok, _} = ClientStateMachine.start_link(session)

    # forall commands <- list( oneof([return({:reset, []}), return({:vote, oneof([return("1"), return("2"), return("3")])})]) ) do
    # forall commands <- list( oneof([return(:reset)]) ) do
      # commands
      # |> Enum.each(fn {command, args} ->
      #   {:ok, expected, actual} = apply(ClientStateMachine, command, [args])
      #   ensure expected == actual
      # end)
    #   collect command: commands do
    #     {c, args} = command
    #     {:ok, expected, actual} = apply(ClientStateMachine, c, [args])
    #     expected == actual
    #   end
    # end
  # end
end
