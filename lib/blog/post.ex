defmodule Blog.Post do
  use Blog.Schema

  schema "posts" do
    has_many :comments, Blog.Comment

    field :title, :string
    field :author, :string
    field :body, :string

    timestamps()
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [:title, :author, :body])
    |> validate_required([:title, :author, :body])
  end
end
