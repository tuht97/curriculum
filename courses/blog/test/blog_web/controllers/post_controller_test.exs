defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase

  import Blog.PostsFixtures
  import Blog.AccountsFixtures

  @create_attrs %{title: "some title", subtitle: "some subtitle", content: "some content"}
  @update_attrs %{
    content: "some updated content",
    title: "some updated title"
  }
  @invalid_attrs %{content: nil, title: nil}

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, ~p"/posts")
      assert html_response(conn, 200) =~ "Listing Posts"
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      user = user_fixture()
      conn = conn |> log_in_user(user) |> get(~p"/posts/new")
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)

      create_attrs = %{
        content: "some content",
        title: "some title",
        visible: true,
        published_on: DateTime.utc_now(),
        user_id: user.id
      }

      conn = post(conn, ~p"/posts", post: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/posts/#{id}"

      conn = get(conn, ~p"/posts/#{id}")
      assert html_response(conn, 200) =~ "Post #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      conn = log_in_user(conn, user)
      conn = post(conn, ~p"/posts", post: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    test "renders form for editing chosen post", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      conn = conn |> log_in_user(user) |> get(~p"/posts/#{post}/edit")
      assert html_response(conn, 200) =~ "Edit Post"
    end

    test "a user cannot edit another user's post", %{conn: conn} do
      post_user = user_fixture()
      other_user = user_fixture()
      post = post_fixture(user_id: post_user.id)
      conn = conn |> log_in_user(other_user) |> get(~p"/posts/#{post}/edit")

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "You can only edit or delete your own posts."

      assert redirected_to(conn) == ~p"/posts/#{post}"
    end
  end

  describe "update post" do
    test "redirects when data is valid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      conn = log_in_user(conn, user)
      conn = put(conn, ~p"/posts/#{post}", post: @update_attrs)
      assert redirected_to(conn) == ~p"/posts/#{post}"

      conn = get(conn, ~p"/posts/#{post}")
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(user_id: user.id)
      conn = conn |> log_in_user(user) |> put(~p"/posts/#{post}", post: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Post"
    end

    test "a user cannot update another user's post", %{conn: conn} do
      post_user = user_fixture()
      other_user = user_fixture()
      post = post_fixture(user_id: post_user.id)
      conn = conn |> log_in_user(other_user) |> put(~p"/posts/#{post}", post: @update_attrs)

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "You can only edit or delete your own posts."

      assert redirected_to(conn) == ~p"/posts/#{post}"
    end
  end

  describe "delete post" do
    test "a user cannot delete another user's post", %{conn: conn} do
      post_user = user_fixture()
      other_user = user_fixture()
      post = post_fixture(user_id: post_user.id)
      conn = conn |> log_in_user(other_user) |> delete(~p"/posts/#{post}")

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "You can only edit or delete your own posts."

      assert redirected_to(conn) == ~p"/posts/#{post}"
    end
  end

  describe "search for posts" do
    test "search for posts - non-matching", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(title: "some title", user_id: user.id)
      conn = get(conn, ~p"/posts", title: "Non-Matching")
      refute html_response(conn, 200) =~ post.title
    end

    test "search for posts - exact match", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(title: "some title", user_id: user.id)
      conn = get(conn, ~p"/posts", title: "some title")
      assert html_response(conn, 200) =~ post.title
    end

    test "search for posts - partial match", %{conn: conn} do
      user = user_fixture()
      post = post_fixture(title: "some title", user_id: user.id)
      conn = get(conn, ~p"/posts", title: "itl")
      assert html_response(conn, 200) =~ post.title
    end
  end

  defp create_post(_) do
    post = post_fixture()
    %{post: post}
  end
end
