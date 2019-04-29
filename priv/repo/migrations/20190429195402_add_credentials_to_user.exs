defmodule Demo.Repo.Migrations.AddCredentialsToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
      add :password, :string
    end
  end
end
