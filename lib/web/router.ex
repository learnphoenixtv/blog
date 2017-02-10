defmodule Blog.Web.Router do
  use Blog.Web, :router

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

  scope "/", Blog.Web do
    pipe_through :browser # Use the default browser stack

    resources "/", PostController do
      resources "/comments", CommentController, only: [:new, :create]
    end
  end
end
