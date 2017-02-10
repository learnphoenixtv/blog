defmodule Blog.Comment do
  use Blog.Schema

  schema "comments" do
    belongs_to :post, Blog.Post

    field :author, :string
    field :body, :string

    timestamps()
  end

  def changeset(schema, params \\ %{}) do
    schema
    |> cast(params, [:author, :body])
    |> validate_required([:post_id, :author, :body])
    |> assoc_constraint(:post)
  end
end
