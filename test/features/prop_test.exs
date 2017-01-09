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

    ptest commands: gen_commands() do
      commands
      |> Enum.each(&run_command/1)
    end
  end

  def run_command({command, args}) do
    apply(ClientStateMachine, command, args)
  end

end
