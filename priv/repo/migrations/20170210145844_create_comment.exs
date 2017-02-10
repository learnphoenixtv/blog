defmodule Blog.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :post_id, references(:posts, on_delete: :delete_all)
      add :author, :string
      add :body, :string

      timestamps()
    end

    create index(:comments, [:post_id])
  end
end
