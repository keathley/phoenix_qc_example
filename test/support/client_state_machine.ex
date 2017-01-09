defmodule PhoenixQcExample.ClientStateMachine do
  use GenServer
  use Wallaby.DSL

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(session) do
    session
    |> visit("/")

    {:ok, %{session: session}}
  end

  def reset() do
    GenServer.call(__MODULE__, :reset)
  end

  def vote(id) do
    GenServer.call(__MODULE__, {:vote, id})
  end

  def handle_call(:reset, _from, %{session: session}) do
    session
    |> click_button("reset")

    {:reply, {:ok, session}, %{session: session}}
  end

  def handle_call({:vote, id}, _from, %{session: session}) do
    session
    |> find(".vote-button[data-id='#{id}']")
    |> click()

    {:reply, {:ok, session}, %{session: session}}
  end
end
