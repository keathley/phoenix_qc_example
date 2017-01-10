defmodule PhoenixQcExample.PropTest do
  use PhoenixQcExample.FeatureCase, async: true
  use Quixir

  alias PhoenixQcExample.ClientStateMachine
  import PhoenixQcExample.Generators

  test "there are options" do
    {:ok, session} = Wallaby.start_session

    options =
      session
      |> visit("/")
      |> find(".choice", count: 3)

    assert options
  end

  test "users get the correct votes" do
    client = gen_csm()
    ptest [commands: gen_commands([client])], repeat_for: 10, trace: true do
      commands
      |> Enum.each(& run_command(&1) )
    end
  end

  @tag :focus
  test "a user should never loose other users votes" do
    clients = [gen_csm(), gen_csm(), gen_csm(), gen_csm()]
    ptest [commands: gen_commands(clients)], repeat_for: 10, trace: true do
      commands
      |> Enum.map(& Task.async(fn -> run_command(&1) end) )
      |> Enum.map(& Task.await(&1) )
      |> Enum.each(fn {expected, actual} -> assert expected >= actual end)
    end
  end

  def run_command({command, pid, args}) do
    {:ok, expected, actual} = apply(ClientStateMachine, command, [pid, args])
    {expected, actual}
  end
end
