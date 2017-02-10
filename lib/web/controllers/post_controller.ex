defmodule Blog.Web.PostController do
  use Blog.Web, :controller

  plug :assign_post when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    render conn, "index.html", posts: Blog.list_posts()
  end

  def new(conn, _params) do
    render conn, "new.html", changeset: Blog.changeset(:post)
  end

  def create(conn, %{"post" => post_params}) do
    case Blog.insert_post(post_params) do
      {:ok, post} ->
        success(conn, "Post created!", post_path(conn, :show, post.id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Oops! There were errors on the form.")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, _params) do
    render conn, "show.html"
  end

  def edit(conn, _params) do
    render conn, "edit.html", changeset: Blog.changeset(conn.assigns.post)
  end

  def update(conn, %{"post" => post_params}) do
    case Blog.update_post(conn.assigns.post, post_params) do
      {:ok, post} ->
        success(conn, "Post updated!", post_path(conn, :show, post.id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Oops! There were errors on the form.")
        |> render("edit.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    case Blog.delete_post(conn.assigns.post) do
      {:ok, _post} ->
        success(conn, "Post deleted!", post_path(conn, :index))
      {:error, _changeset} ->
        error(conn, "Post could not be deleted!", post_path(conn, :index))
    end
  end

  defp assign_post(conn, _opts) do
    case Blog.get_post(conn.params["id"]) do
      %Blog.Post{} = post ->
        assign(conn, :post, post)
      nil ->
        conn
        |> put_flash(:error, "Post not found!")
        |> redirect(to: post_path(conn, :index))
    end
  end
end
