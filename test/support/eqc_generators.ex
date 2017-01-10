defmodule PhoenixQcExample.EqcGenerators do
  alias PhoenixQcExample.ClientStateMachine, as: CSM

  defmacro gen_commands() do
    quote do
      list(command(clients()))
    end
  end

  defmacro command(clients) do
    quote do
      oneof([gen_reset(clients()), gen_vote(clients())])
    end
  end

  defmacro clients() do
    quote do
      [client()]
    end
  end

  defmacro client() do
    quote do
      {:ok, session} = Wallaby.start_session()
      {:ok, pid} = CSM.start_link(session)

      pid
    end
  end

  defmacro gen_reset(clients) do
    quote do
      {:reset, oneof(unquote(clients)), []}
    end
  end

  defmacro gen_vote(clients) do
    quote do
      {:vote, oneof(unquote(clients)), oneof([1,2,3])}
    end
  end
end
