alias MatrixSDK.Client
alias MatrixSDK.Client.Request

defmodule Apagati.MatrixClient do
  @moduledoc """
  The MatrixClient context.
  """

  import Ecto.Query, warn: false

  require Logger
  alias Apagati.Repo

  @base_server "https://matrix.org"

  alias Apagati.MatrixClient.Room

  def get_token() do
    response =
      @base_server
      |> Request.register_guest()
      |> Client.do_request()

    token = get_token_from_response(response)
    token
  end

  defp get_token_from_response({:ok, %Tesla.Env{body: body}}) do
    Map.get(body, "access_token")
  end

  defp get_token_from_response({:error, _response} = error), do: error

  def join_room(token, room) do
    response =
      @base_server
      |> Request.join_room(token, room)
      |> Client.do_request()


    Logger.info("room body")
    data = {:ok, %Tesla.Env{body: body, status: status}} = response
    IO.inspect(body)
    body
  end


  # defp handle_room_econnect({:ok, %Tesla.Env{body: body, status: status}}) do
  #   IO.inspect(body)
  # end

  # defp handle_room_econnect({:ok, %Tesla.Env{body: body, status: 200}}) do
  #   IO.inspect("ok")
  # end


  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{data: %Room{}}

  """
  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end
end
