defmodule PhoenixQcExample.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      import PhoenixQcExample.Router.Helpers
    end
  end
end
