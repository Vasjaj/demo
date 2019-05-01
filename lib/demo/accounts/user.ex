defmodule Demo.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  @derive {Poison.Encoder, only: [:email, :provider]}

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    # field :username, :string
    # field :password, :string
    has_many :posts, Demo.Posts.Post
    has_many :comments, Demo.Posts.Comment

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end
end
