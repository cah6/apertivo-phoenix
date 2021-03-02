defmodule Apertivo.HappyHours do
  @moduledoc """
  The HappyHours context.
  """

  import Ecto.Query, warn: false
  alias Apertivo.Repo

  alias Apertivo.HappyHours.HappyHour

  @doc """
  Returns the list of happy_hours.

  ## Examples

      iex> list_happy_hours()
      [%HappyHour{}, ...]

  """
  def list_happy_hours do
    Repo.all(HappyHour)
  end

  @doc """
  Gets a single happy_hour.

  Raises `Ecto.NoResultsError` if the Happy hour does not exist.

  ## Examples

      iex> get_happy_hour!(123)
      %HappyHour{}

      iex> get_happy_hour!(456)
      ** (Ecto.NoResultsError)

  """
  def get_happy_hour!(id), do: Repo.get!(HappyHour, id)

  @doc """
  Creates a happy_hour.

  ## Examples

      iex> create_happy_hour(%{field: value})
      {:ok, %HappyHour{}}

      iex> create_happy_hour(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_happy_hour(attrs \\ %{}) do
    %HappyHour{}
    |> HappyHour.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a happy_hour.

  ## Examples

      iex> update_happy_hour(happy_hour, %{field: new_value})
      {:ok, %HappyHour{}}

      iex> update_happy_hour(happy_hour, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_happy_hour(%HappyHour{} = happy_hour, attrs) do
    happy_hour
    |> HappyHour.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a happy_hour.

  ## Examples

      iex> delete_happy_hour(happy_hour)
      {:ok, %HappyHour{}}

      iex> delete_happy_hour(happy_hour)
      {:error, %Ecto.Changeset{}}

  """
  def delete_happy_hour(%HappyHour{} = happy_hour) do
    Repo.delete(happy_hour)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking happy_hour changes.

  ## Examples

      iex> change_happy_hour(happy_hour)
      %Ecto.Changeset{data: %HappyHour{}}

  """
  def change_happy_hour(%HappyHour{} = happy_hour, attrs \\ %{}) do
    HappyHour.changeset(happy_hour, attrs)
  end
end
