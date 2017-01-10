defmodule PhoenixQcExample.ClientStateMachine do
  use GenServer
  use Wallaby.DSL

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(session) do
    session
    |> visit("/")

    {:ok, %{session: session}}
  end

  def reset(pid, _) do
    GenServer.call(pid, :reset)
  end

  def vote(pid, id) do
    GenServer.call(pid, {:vote, id})
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
    # IO.puts "Voting for #{id}"
    {old_count, _} =
      session
      |> find(".vote-count[data-voter-id='#{id}']")
      |> text()
      |> Integer.parse()

    session
    |> find(".vote-button[data-id='#{id}']")
    |> click()

    # Error
    # expected_count = old_count
    expected_count = old_count + 1

    # IO.puts "Old count: #{old_count}"
    # IO.puts "Expected Count: #{expected_count}"

    {new_count, _} =
      session
      # |> find(".vote-count[data-voter-id='#{id}']", text: Integer.to_string(expected_count))
      |> find(".vote-count[data-voter-id='#{id}']")
      |> text()
      |> Integer.parse()

    # IO.puts("New Count: #{new_count}")

    {:reply, {:ok, expected_count, new_count}, %{session: session}}
  end
end
