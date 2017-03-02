defmodule PhoenixQcExample.VotesController do
  use PhoenixQcExample.Web, :controller
  alias PhoenixQcExample.VoteCounter

  def new(conn, %{"id" => id, "name" => name}) do
    # This is the bad version.
    # {:ok, current_votes} = VoteCounter.get(id)
    # new_votes = [name | current_votes]
    # VoteCounter.put(id, new_votes)

    # This is the good version.
    {:ok, new_votes} = VoteCounter.incr(id, name)

    # Other nonsense

    PhoenixQcExample.Endpoint.broadcast!("room:voting", "new:vote", %{id: id, votes: new_votes})

    users_votes =
      new_votes
      |> Enum.filter(fn vote -> vote == name end)
      |> Enum.count()

    json conn, %{id: id, votes: users_votes}
  end

  def reset(conn, _) do
    {:ok, new_votes} = VoteCounter.reset()

    PhoenixQcExample.Endpoint.broadcast!("room:voting", "reset", %{votes: new_votes})
    json conn, new_votes
  end
end
