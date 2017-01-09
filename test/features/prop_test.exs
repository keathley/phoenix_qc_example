defmodule PhoenixQcExample.PropTest do
  use PhoenixQcExample.FeatureCase, async: true
  use Quixir

  alias PhoenixQcExample.ClientStateMachine
  import PhoenixQcExample.Generators

  test "there are options", %{session: session} do
    options =
      session
      |> visit("/")
      |> find(".choice", count: 3)

    assert options
  end

  test "users get the correct votes", %{session: session} do
    {:ok, _} = ClientStateMachine.start_link(session)

    ptest [commands: gen_commands()], repeat_for: 10 do
      PhoenixQcExample.VoteCounter.reset()
      commands
      |> Enum.each(fn {command, args} ->
        {:ok, expected, actual} = apply(ClientStateMachine, command, [args])
        assert expected == actual
      end)
    end
  end
end
