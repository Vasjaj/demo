defmodule DemoWeb.PostController do
  use DemoWeb, :controller

  alias Demo.Posts
  alias Demo.Posts.Post
  alias Demo.Repo

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    changeset =
      if conn.assigns.user do
        conn.assigns.user
        |> Ecto.build_assoc(:posts)
        |> Post.changeset(post_params)
      else
        %Post{}
        |> Post.changeset(post_params)
      end

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    render(conn, "show.html", post: Repo.preload(post, :user))
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id)

    cond do
      conn.assigns.user == nil ->
        conn
        |> put_flash(:info, "You are not logged in")
        |> redirect(to: Routes.post_path(conn, :index))
      conn.assigns.user && conn.assigns.user.id != post.user_id ->
        conn
        |> put_flash(:info, "You are not the owner of this post")
        |> redirect(to: Routes.post_path(conn, :index))
      true ->
        changeset = Posts.change_post(post)
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)

    cond do
      conn.assigns.user == nil ->
        conn
        |> put_flash(:info, "You are not logged in")
        |> redirect(to: Routes.post_path(conn, :index))
      conn.assigns.user && conn.assigns.user.id != post.user_id ->
        conn
        |> put_flash(:info, "You are not the owner of this post")
        |> redirect(to: Routes.post_path(conn, :index))
      true ->
        {:ok, _post} = Posts.delete_post(post)
        conn
        |> put_flash(:info, "Post deleted successfully.")
        |> redirect(to: Routes.post_path(conn, :index))
    end
  end
end
