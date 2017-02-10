defmodule Blog.Factory do
  def build(:post) do
    %Blog.Post{
      title: "My first blog post",
      author: "Daniel Berkompas",
      body: "Hello world!"
    }
  end

  def build(:post_with_comments) do
    build(:post, comments: [
      build(:comment, body: "Worst post ever!"),
      build(:comment, body: "I love this post")
    ])
  end

  def build(:comment) do
    %Blog.Comment{
      author: "Daniel Berkompas",
      body: "Best post ever!"
    }
  end

  def build(factory, attributes) do
    factory
    |> build()
    |> struct(attributes)
  end

  def insert!(factory, attributes \\ []) do
    factory
    |> build(attributes)
    |> Blog.Repo.insert!
  end
end
