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

  def reset(_) do
    GenServer.call(__MODULE__, :reset)
  end

  def vote(id) do
    GenServer.call(__MODULE__, {:vote, id})
  end

  def handle_call(:reset, _from, %{session: session}) do
    session
    |> click_button("reset")

    votes =
      session
      |> find(".vote-count", count: 3, text: "0")
      |> Enum.map(&text/1)

    {:reply, {:ok, votes, ["0", "0", "0"]}, %{session: session}}
  end

  def handle_call({:vote, id}, _from, %{session: session}) do
    {old_count, _} =
      session
      |> find(".vote-count[data-voter-id='#{id}']")
      |> text()
      |> Integer.parse()

    session
    |> find(".vote-button[data-id='#{id}']")
    |> click()

    expected_count = old_count

    {new_count, _} =
      session
      |> find(".vote-count[data-voter-id='#{id}']")
      |> text()
      |> Integer.parse()

    {:reply, {:ok, expected_count, new_count}, %{session: session}}
  end
end
