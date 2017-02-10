defmodule Blog.Web.Controller do
  @moduledoc """
  Helper functions for controllers.
  """

  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  @doc """
  Stores a success message in the flash, and then redirects to the desired location.
  """
  def success(conn, message, redirect_path) do
    msg(conn, :success, message, redirect_path)
  end

  @doc """
  Stores an error message in the flash, and then redirects to the desired location.
  """
  def error(conn, message, redirect_path) do
    msg(conn, :error, message, redirect_path)
  end

  defp msg(conn, type, message, redirect_path) do
    conn
    |> put_flash(type, message)
    |> redirect(to: redirect_path)
  end
end
