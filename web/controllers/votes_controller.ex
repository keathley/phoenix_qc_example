defmodule PhoenixQcExample.VotesController do
  use PhoenixQcExample.Web, :controller
  alias PhoenixQcExample.VoteCounter

  def new(conn, %{"id" => id}) do
    {:ok, current_count} = VoteCounter.get(id)
    new_count = current_count + 1
    VoteCounter.put(id, new_count)

    PhoenixQcExample.Endpoint.broadcast!("room:voting", "new:vote", %{id: id, count: new_count})
    json conn, %{id: id, count: new_count}
  end

  def reset(conn, _) do
    {:ok, new_counts} = VoteCounter.reset()

    PhoenixQcExample.Endpoint.broadcast!("room:voting", "reset", %{counts: new_counts})
    json conn, new_counts
  end
end
