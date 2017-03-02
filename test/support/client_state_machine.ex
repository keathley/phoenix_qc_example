defmodule PhoenixQcExample.ClientStateMachine do

  def vote(name, id) do
    %{"votes" => new_votes} = post(id, name)
    {:ok, new_votes}
  end

  def vote_next(state, [id, name], _result) do
    {:ok, update_in(state, [name, to_string(id)], &(&1 + 1))}
  end

  def vote_post(state, [id, name], actual_result) do
    expected_result = get_in(state, [name, to_string(id)]) + 1

    {:ok, actual_result == expected_result}
  end

  defp post(id, name) do
    {:ok, json} = HTTPoison.post url(id), body(name), content_type()
    {:ok, parsed} = Poison.decode(json.body)
    parsed
  end

  def body(name) do
    "{\"name\": \"#{name}\"}"
  end

  defp url(id) do
    "http://localhost:4001/api/restaurants/#{id}/votes"
  end

  defp content_type() do
    [{"Content-Type", "application/json"}]
  end
end
