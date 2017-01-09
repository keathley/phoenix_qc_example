defmodule PhoenixQcExample.PropTest do
  use PhoenixQcExample.FeatureCase, async: true

  test "there are options", %{session: session} do
    options =
      session
      |> visit("/")
      |> find(".choice", count: 3)

    assert options
  end
end
