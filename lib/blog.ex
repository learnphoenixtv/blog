defmodule Blog do
  @moduledoc """
  The brain of the blog.

  Phoenix 1.3 calls these business logic modules "Context" modules. Each context
  module gets a folder in lib/ to put its related modules in. (In this case, the
  lib/blog directory contains the schemas we need)
  
  Since this app is so simple we only need one context module, with the same 
  name as the app: `Blog`.
  """

  import Ecto.Query

  alias Blog.{
    Comment,
    Post,
    Repo
  }

  @doc """
  Generates a changeset for the given schema.
  """
  @spec changeset(atom | map) :: Ecto.Changeset.t
  def changeset(:post) do
    Post.changeset(%Post{})
  end
  def changeset(:comment) do
    Comment.changeset(%Comment{})
  end
  def changeset(schema) when is_map(schema) do
    schema.__struct__.changeset(schema)
  end

  @doc """
  Returns all the posts from the database.
  """
  @spec list_posts :: [Post.t]
  def list_posts do
    Post
    |> order_by(desc: :inserted_at)
    |> preload(:comments)
    |> Repo.all
  end

  @doc """
  Finds a post by its numeric ID.
  """
  @spec get_post(integer) :: nil | Post.t
  def get_post(id) do
    Post
    |> Repo.get(id)
    |> Repo.preload(:comments)
  end

  @doc """
  Inserts a post into the database.

  ## Params
  
      %{
        "title" => "Hello World",
        "author" => "Daniel Berkompas",
        "body" => "Post here"
      }
  """
  @spec insert_post(map) :: 
    {:ok, Post.t} | 
    {:error, Ecto.Changeset.t}
  def insert_post(params) do
    %Post{}
    |> Post.changeset(params)
    |> Repo.insert
  end

  @doc """
  Updates a post. Use `get_post/1` to find the post first.

  ## Example

      post = Blog.get_post(123)
      Blog.update_post(post, %{
        "title" => "Hello World",
        "author" => "Daniel Berkompas",
        "body" => "Post here"
      })
  """
  @spec update_post(Post.t, map) :: 
    {:ok, Post.t} | 
    {:error, Ecto.Changeset.t}
  def update_post(post, params) do
    post
    |> Post.changeset(params)
    |> Repo.update
  end

  @doc """
  Deletes a post. Use `get_post/1` to find the post first.

  ## Example
  
      post = Blog.get_post(123)
      Blog.delete_post(post)
  """
  @spec delete_post(Post.t) :: 
    {:ok, Post.t} | 
    {:error, Ecto.Changeset.t}
  def delete_post(post) do
    Repo.delete(post)
  end

  @doc """
  Inserts a comment for a given post.

  ## Example
  
      Blog.insert_comment(123, %{
        "author" => "Daniel Berkompas",
        "body" => "Comment here"
      })
  """
  @spec insert_comment(integer, map) :: 
    {:ok, Comment.t} | 
    {:error, Ecto.Changeset.t}
  def insert_comment(post_id, params) do
    %Comment{post_id: post_id}
    |> Comment.changeset(params)
    |> Repo.insert
  end
end
