defmodule PhoenixQcExample.PropTest do
  use PhoenixQcExample.FeatureCase, async: true
  use Quixir

  alias PhoenixQcExample.ClientStateMachine, as: Client
  import PhoenixQcExample.Generators
  alias PhoenixQcExample.VoteCounter

  @tag :focus
  test "users don't effect each others votes" do
    ptest [commands: gen_commands()] do
      VoteCounter.reset()
      {_state, result} = run_parallel_commands(commands, Client)
      assert result
    end
  end

  def run_p_commands([l1, l2], module) do
    t1 = Task.async(fn -> run_commands(l1, module) end)
    t2 = Task.async(fn -> run_commands(l2, module) end)
    {_, ra} = Task.await(t1)
    {_, rb} = Task.await(t2)
    {:ok, ra && rb}
  end

  def run_parallel_commands(commands, module) do
    {l1, l2} = split_commands(commands)
    t1 = Task.async(fn -> run_commands(l1, module) end)
    t2 = Task.async(fn -> run_commands(l2, module) end)
    {_, ra} = Task.await(t1)
    {_, rb} = Task.await(t2)
    {nil, ra && rb}
  end

  def split_commands(commands) do
    chris = Enum.filter(commands, fn {_, name, _} -> name == "chris" end)
    jane = Enum.filter(commands, fn {_, name, _} -> name == "jane" end)
    {chris, jane}
  end

  def run_commands(commands, module) do
    init_state = %{
      "chris" => %{"1" => 0, "2" => 0, "3" => 0},
      "jane" => %{"1" => 0, "2" => 0, "3" => 0},
    }
    Enum.reduce(commands, {init_state, true}, & run_command(module, &1, &2) )
  end

  def run_command(module, {command, name, args}, {state, result}) do
    {:ok, actual_result} = apply(module, command, [name, args])
    {:ok, new_state} = apply(module, :"#{command}_next", [state, [args, name], result])
    {:ok, new_result} = apply(module, :"#{command}_post", [state, [args, name], actual_result])

    {new_state, new_result}
  end
end
