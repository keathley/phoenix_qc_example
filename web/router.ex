defmodule PhoenixQcExample.Router do
  use PhoenixQcExample.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixQcExample do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", PhoenixQcExample do
    pipe_through :api

    post "/restaurants/:id/votes", VotesController, :new
    post "/reset", VotesController, :reset
  end
end
