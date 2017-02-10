defmodule Blog.Test do
  use Blog.DataCase, async: true

  describe ".list_posts" do
    test "returns posts, ordered by inserted_at, with comments" do
      old = Factory.insert!(:post_with_comments, inserted_at: ~N[2000-01-01 00:00:00])
      recent = Factory.insert!(:post_with_comments, inserted_at: ~N[2001-01-01 00:00:00])

      [first, second] = Blog.list_posts()
      assert first.id == recent.id
      assert second.id == old.id
      assert length(first.comments) > 0
      assert length(second.comments) > 0
    end

    test "returns empty list when there are no posts" do
      assert [] = Blog.list_posts()
    end
  end

  describe ".get_post" do
    test "returns post by ID if it exists" do
      %{id: id} = Factory.insert!(:post_with_comments)
      post = Blog.get_post(id)

      assert post.__struct__ == Blog.Post
      assert length(post.comments) > 0
    end

    test "returns nil if post does not exist" do
      assert Blog.get_post(123) == nil
    end
  end

  describe ".insert_post" do
    test "requires valid parameters" do
      {:error, changeset} = Blog.insert_post(%{})
      assert Keyword.keys(changeset.errors) == [:title, :author, :body]
    end

    test "inserts a post" do
      {:ok, post} = 
        Blog.insert_post(%{
          "title" => "Test Post",
          "author" => "Automated Tester",
          "body" => "Hello world"
        })

      assert post.title == "Test Post"
      assert post.author == "Automated Tester"
      assert post.body == "Hello world"
      assert post.inserted_at
    end
  end

  describe ".update_post" do
    setup do
      [post: Factory.insert!(:post)]
    end

    test "requires valid parameters", %{post: post} do
      {:error, changeset} = 
        Blog.update_post(post, %{
          "title" => nil,
          "author" => nil,
          "body" => nil
        })

      assert Keyword.keys(changeset.errors) == [:title, :author, :body]
    end

    test "updates a post", %{post: post} do
      {:ok, post} = 
        Blog.update_post(post, %{
          "title" => "New Title",
          "author" => "New Author",
          "body" => "New body"
        })

      assert post.title == "New Title"
      assert post.author == "New Author"
      assert post.body == "New body"
    end
  end

  describe ".delete_post" do
    test "deletes a post" do
      post = Factory.insert!(:post)
      {:ok, _post} = Blog.delete_post(post)
      assert Repo.aggregate(Blog.Post, :count, :id) == 0
    end
  end

  describe ".insert_comment" do
    test "requires valid parameters" do
      {:error, changeset} = Blog.insert_comment(123, %{})
      assert Keyword.keys(changeset.errors) == [:author, :body]
    end

    test "requires a valid post_id" do
      {:error, changeset} =
        Blog.insert_comment(123, %{
          "author" => "Valid author",
          "body" => "Valid body"
        })

      assert Keyword.keys(changeset.errors) == [:post]
    end
  end
end
