defmodule CodeRacing.Router do
  use CodeRacing.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CodeRacing.UserKeyMatchValidator
    plug :accepts, ["json"]
  end

  scope "/", CodeRacing do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/", CodeRacing do
    pipe_through :api

    resources "/register", UserController, only: [:create]
    resources "/challenge", ChallengesController, only: [:index]
  end
end
