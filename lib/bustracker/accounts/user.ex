defmodule Bustracker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    has_many :log, Bustracker.History.Log, on_delete: :nilify_all, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :password_confirmation])
    |> unique_constraint(:email)
    |> validate_email(:email)
    |> validate_confirmation(:password)
    |> validate_password(:password)
    |> put_pass_hash()
    |> validate_required([:email, :name, :password_hash])
  end

  # ensure that the email looks valid
 def validate_email(changeset, field, options \\ []) do
   validate_change(changeset, field, fn _, email ->
     # Below line taken from https://gist.github.com/mgamini/4f3a8bc55bdcc96be2c6
     case Regex.run(~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, email) do
       nil ->
        [{field, options[:message] || "Invalid Email"}]
      _->[]
       end
   end)
 end

    # Password validation
    # From Comeonin docs
    def validate_password(changeset, field, options \\ []) do
      validate_change(changeset, field, fn _, password ->
        case valid_password?(password) do
          {:ok, _} -> []
          {:error, msg} -> [{field, options[:message] || msg}]
        end
      end)
    end

    def put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
      change(changeset, Comeonin.Argon2.add_hash(password))
    end
    def put_pass_hash(changeset), do: changeset

    def valid_password?(password) when byte_size(password) > 7 do
      {:ok, password}
    end
    def valid_password?(_), do: {:error, "The password is too short"}

end
