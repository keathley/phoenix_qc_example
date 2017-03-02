defmodule PhoenixQcExample.VoteChannel do
  use Phoenix.Channel
  alias PhoenixQcExample.VoteCounter

  def join("room:voting", _message, socket) do
    {:ok, initial_votes} = VoteCounter.all()

    {:ok, %{votes: initial_votes}, socket}
  end
  def join("room:" <> _, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
