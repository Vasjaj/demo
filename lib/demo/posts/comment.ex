defmodule Demo.Posts.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string
    belongs_to :user, Demo.Accounts.User
    belongs_to :post, Demo.Posts.Post

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :content])
    |> validate_required([:content, :content])
  end
end
