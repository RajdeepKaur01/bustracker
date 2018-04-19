defmodule Bustracker.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :stop, :string
      add :route, :string
      add :directionId, :string
      add :schedule, :naive_datetime
      add :predicted, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:logs, [:user_id])
  end
end
