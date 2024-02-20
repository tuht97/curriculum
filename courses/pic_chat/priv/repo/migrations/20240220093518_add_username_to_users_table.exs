defmodule PicChat.Repo.Migrations.AddUsernameToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:username, :string, null: false)
    end
  end
end
