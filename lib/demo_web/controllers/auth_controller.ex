defmodule DemoWeb.AuthController do
  use DemoWeb, :controller

  alias Demo.Accounts.User
  alias Demo.Repo

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case auth.info.email do
      nil ->
        # require IEx; IEx.pry
        conn
        |> put_flash(:error, "Provided email is empty")
        |> redirect(to: Routes.post_path(conn, :index))
      email ->
        user_params = %{
          token: auth.credentials.token,
          email: auth.info.email,
          provider: Atom.to_string(auth.provider)
        }

        changeset = User.changeset(%User{}, user_params)

        sign_in(conn, changeset)
    end
  end

  def sign_out(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.post_path(conn, :index))
  end

  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.post_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error singing in")
        |> redirect(to: Routes.post_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end