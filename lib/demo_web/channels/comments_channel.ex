defmodule DemoWeb.CommentsChannel do
  use DemoWeb, :channel
  
  alias Demo.Posts.{Comment, Post}
  alias Demo.Repo

  def join("comments:" <> post_id, _params, socket) do
    post_id = String.to_integer(post_id)

    post =
      Post
      |> Repo.get(post_id)
      |> Repo.preload(comments: [:user])

    {:ok, %{comments: post.comments}, assign(socket, :post, post)}
  end

  def handle_in(_name, %{"content" => content}, socket) do
    post = socket.assigns.post
    user_id = socket.assigns.user_id

    changeset =
      post
      |> Ecto.build_assoc(:comments, user_id: user_id)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(
          socket,
          "comments:#{socket.assigns.post.id}:new",
          %{comment: Repo.preload(comment, :user)}
        )

        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end