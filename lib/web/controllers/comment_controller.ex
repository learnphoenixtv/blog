defmodule Blog.Web.CommentController do
  use Blog.Web, :controller

  def new(conn, _params) do
    render conn, "new.html", changeset: Blog.changeset(:comment)
  end

  def create(conn, %{"post_id" => post_id, "comment" => comment_params}) do
    result =
      post_id
      |> String.to_integer
      |> Blog.insert_comment(comment_params)

    case result do
      {:ok, _comment} ->
        success(conn, "Comment created!", post_path(conn, :show, post_id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Oops! There were errors on the form.")
        |> render("new.html", changeset: changeset)
    end
  end
end
