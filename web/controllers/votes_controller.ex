defmodule PhoenixQcExample.VotesController do
  use PhoenixQcExample.Web, :controller
  alias PhoenixQcExample.VoteCounter

  def new(conn, %{"id" => id, "name" => name}) do
    {:ok, current_votes} = VoteCounter.get(id)
    IO.puts "Getting current votes"
    IO.inspect(current_votes)
    new_votes = [name | current_votes]
    IO.inspect(new_votes)
    VoteCounter.put(id, new_votes)

    PhoenixQcExample.Endpoint.broadcast!("room:voting", "new:vote", %{id: id, votes: new_votes})
    json conn, %{id: id, votes: new_votes}
  end

  def reset(conn, _) do
    {:ok, new_votes} = VoteCounter.reset()

    PhoenixQcExample.Endpoint.broadcast!("room:voting", "reset", %{votes: new_votes})
    json conn, new_votes
  end
end
