defmodule Bustracker.History.Log do
  use Ecto.Schema
  import Ecto.Changeset


  schema "logs" do
    field :directionId, :string
    field :predicted, :naive_datetime
    field :route, :string
    field :schedule, :naive_datetime
    field :stop, :string
    belongs_to :user, Bustracker.Accounts.User, foreign_key: :user_id
    # field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:stop, :route, :directionId, :schedule, :predicted, :user_id])
    |> validate_required([:stop, :route, :directionId, :user_id])
  end
end
