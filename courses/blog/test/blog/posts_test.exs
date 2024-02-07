defmodule Blog.PostsTest do
  use Blog.DataCase

  alias Blog.Comments
  alias Blog.Posts
  alias Blog.Tags
  alias Blog.Posts.Post
  alias Blog.Posts.CoverImage

  import Blog.AccountsFixtures
  import Blog.CommentsFixtures
  import Blog.PostsFixtures
  import Blog.TagsFixtures

  describe "posts" do
    @invalid_attrs %{title: nil, subtitle: nil, content: nil}

    test "list_posts/0 with no filter returns all posts" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert Posts.list_posts() |> Enum.map(& &1.id) == [post] |> Enum.map(& &1.id)
    end

    test "list_posts/1 ignores non visible posts" do
      user = user_fixture()
      post = post_fixture(visible: false, user_id: user.id)
      assert Posts.list_posts() == []
      assert Posts.list_posts(post.title) == []
    end

    test "list_posts/0 posts are displayed from newest" do
      user = user_fixture()
      posts = Enum.map(1..10, fn i -> post_fixture(title: "title #{i}", user_id: user.id) end)

      is_newest_to_oldest =
        posts
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.all?(fn [p1, p2] ->
          p1.inserted_at >= p2.inserted_at
        end)

      assert is_newest_to_oldest
    end

    test "list_posts/1 filters posts by partial and case-insensitive title" do
      user = user_fixture()
      post = post_fixture(title: "Title", user_id: user.id)

      # non-matching
      assert Posts.list_posts("Non-Matching") == []
      # exact match
      assert Posts.list_posts("Title") |> Repo.preload([:tags]) == [post]
      # partial match end
      assert Posts.list_posts("tle") |> Repo.preload([:tags]) == [post]
      # partial match front
      assert Posts.list_posts("Titl") |> Repo.preload([:tags]) == [post]
      # partial match middle
      assert Posts.list_posts("itl") |> Repo.preload([:tags]) == [post]
      # case insensitive lower
      assert Posts.list_posts("title") |> Repo.preload([:tags]) == [post]
      # case insensitive upper
      assert Posts.list_posts("TITLE") |> Repo.preload([:tags]) == [post]
      # case insensitive and partial match
      assert Posts.list_posts("ITL") |> Repo.preload([:tags]) == [post]
      # empty
      assert Posts.list_posts("") |> Repo.preload([:tags]) == [post]
    end

    test "get_post!/1 returns the post with given id" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      retrieved_post = Posts.get_post!(post.id)
      assert retrieved_post.id == post.id
      assert retrieved_post.title == post.title
      assert retrieved_post.visible == post.visible
      assert retrieved_post.published_on == post.published_on
    end

    test "get_post!/1 loads the cover_image association" do
      user = user_fixture()

      post =
        post_fixture(user_id: user.id, cover_image: %{url: "http://www.example.com/image.png"})

      assert %CoverImage{url: "http://www.example.com/image.png"} =
               Posts.get_post!(post.id).cover_image
    end

    test "create_post/1 with image" do
      valid_attrs = %{
        content: "some content",
        title: "some title",
        cover_image: %{
          url: "https://www.example.com/image.png"
        },
        visible: true,
        published_on: DateTime.utc_now(),
        user_id: user_fixture().id
      }

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)

      assert %CoverImage{url: "https://www.example.com/image.png"} =
               Repo.preload(post, :cover_image).cover_image
    end

    test "create_post/1 with tags" do
      user = user_fixture()
      tag1 = tag_fixture()
      tag2 = tag_fixture()

      valid_attrs1 = %{content: "some content", title: "post 1", user_id: user.id, visible: true}
      valid_attrs2 = %{content: "some content", title: "post 2", user_id: user.id, visible: true}

      assert {:ok, %Post{} = post1} = Posts.create_post(valid_attrs1, [tag1, tag2])
      assert {:ok, %Post{} = post2} = Posts.create_post(valid_attrs2, [tag1])

      # posts have many tags
      assert Repo.preload(post1, :tags).tags == [tag1, tag2]
      assert Repo.preload(post2, :tags).tags == [tag1]

      # tags have many posts
      # we preload posts: [:tags] because posts contain the list of tags when created
      assert Repo.preload(tag1, posts: [:tags]).posts == [post1, post2]
      assert Repo.preload(tag2, posts: [:tags]).posts == [post1]
    end

    test "create_post/1 with valid data creates a post" do
      today = Date.utc_today()
      title = "some title #{today}"
      user = user_fixture()

      valid_attrs = %{
        title: title,
        content: "some content",
        published_on: today,
        visible: true,
        user_id: user.id
      }

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.title == title
      assert post.published_on == today
      assert post.content == "some content"
      assert post.visible == true
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      user = user_fixture()
      post = post_fixture(title: "Title", user_id: user.id)
      today = Date.utc_today()

      update_attrs = %{
        title: "some updated title",
        published_on: today,
        content: "some updated content",
        visible: true
      }

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.title == "some updated title"
      assert post.published_on == today
      assert post.content == "some updated content"
      assert post.visible == true
    end

    test "update_post/1 add an image" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)

      assert {:ok, %Post{} = post} =
               Posts.update_post(post, %{
                 cover_image: %{url: "https://www.example.com/image2.png"}
               })

      assert post.cover_image.url == "https://www.example.com/image2.png"
    end

    test "update_post/1 update existing image" do
      user = user_fixture()

      post =
        post_fixture(user_id: user.id, cover_image: %{url: "https://www.example.com/image.png"})

      assert {:ok, %Post{} = post} =
               Posts.update_post(post, %{
                 cover_image: %{url: "https://www.example.com/image2.png"}
               })

      assert post.cover_image.url == "https://www.example.com/image2.png"
    end

    test "update_post/2 with invalid data returns error changeset" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert Repo.preload(post, [:comments, :user, :cover_image]) == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
