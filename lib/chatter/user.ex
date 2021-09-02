defmodule Chatter.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :encrypt_pass, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
  end

  def reg_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast(params, [:password], [])
    |> validate_length(:password, min: 5)
    |> hash_pw()
  end

  defp hash_pw(changeset) do

    case changeset do
      %Ecto.Changeset{valid? true, changes: %{password: p}} ->
        put_change(changeset,  :encrypt_pass, Comeonin.Pbkdf2.hashpwsalt(p))

        ->
        changeset
    end
  end
end
