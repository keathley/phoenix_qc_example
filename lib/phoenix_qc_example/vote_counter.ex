defmodule PhoenixQcExample.VoteCounter do
  use GenServer

  @default_state %{"1" => 0, "2" => 0, "3" => 0}

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    {:ok, @default_state}
  end

  def get(id) when is_binary(id) do
    GenServer.call(__MODULE__, {:get, id})
  end

  def put(id, value) when is_binary(id) and is_number(value) do
    GenServer.call(__MODULE__, {:put, id, value})
  end

  def all() do
    GenServer.call(__MODULE__, :all)
  end

  def reset() do
    GenServer.call(__MODULE__, :reset)
  end

  def handle_call(:all, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:get, id}, _from, state) do
    count = Map.get(state, id)
    {:reply, {:ok, count}, state}
  end

  def handle_call({:put, id, value}, _from, state) do
    new_state =
      state
      |> Map.put(id, value)

    {:reply, {:ok, new_state[id]}, new_state}
  end

  def handle_call(:reset, _from, _state) do
    {:reply, {:ok, @default_state}, @default_state}
  end
end
