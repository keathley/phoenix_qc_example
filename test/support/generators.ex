defmodule PhoenixQcExample.Generators do
  import Pollution.VG

  alias PhoenixQcExample.ClientStateMachine, as: CSM

  def gen_csm() do
    {:ok, session} = Wallaby.start_session()
    {:ok, pid} = CSM.start_link(session)

    value(pid)
  end

  def gen_commands(clients) do
    # list(of: choose(from: [gen_reset(clients), gen_vote(clients)]), max: 20)
    list(of: choose(from: [gen_vote(clients)]), max: 20)
  end

  def gen_reset(clients) do
    tuple(like: {value(:reset), choose(from: clients), value([])})
  end

  def gen_vote(clients) do
    # tuple(like: {value(:vote), choose(from: clients), choose(from: [value(1), value(2), value(3)])} )
    tuple(like: {value(:vote), choose(from: clients), choose(from: [value(1)])} )
  end
end
