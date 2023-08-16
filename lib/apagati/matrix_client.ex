alias MatrixSDK.Client
alias MatrixSDK.Client.Request
alias HTTPoison

defmodule Apagati.MatrixClient do
  @moduledoc """
  The MatrixClient context.
  """

  import Ecto.Query, warn: false

  require Logger
  alias Apagati.Repo

  @base_server "https://matrix.org/_matrix/client/v3"

  @base_headers [{"Content-Type", "application/json"}]

  alias Apagati.MatrixClient.Room

  # def get_dummy() do
  #   body = {
  #     "type": "m.login.dummy",
  #     "session": "<session ID>"
  #   }

  #   case HTTPoison.post("#{@base_server}/_matrix/client/r0/register?kind=guest", body, @base_headers) do
  #     {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
  #       IO.puts("Request successful. Response body: #{body}")

  #     {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
  #       IO.puts("Request failed with status code: #{status}. Response body: #{body}")

  #     {:error, error} ->
  #       IO.puts("Request failed with error: #{inspect(error)}")
  #   end
  # end


  def login(user, passw, device_name) do
    body = %{
      "identifier" => %{
        "type" => "m.id.user",
        "user" => user
      },
      "initial_device_display_name" => device_name,
      "password" => passw,
      "type" => "m.login.password"
    }


    case HTTPoison.post("#{@base_server}/login", body, @base_headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts("Request successful. Response body: #{body}")

      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        IO.puts("Request failed with status code: #{status}. Response body: #{body}")

      {:error, error} ->
        IO.puts("Request failed with error: #{inspect(error)}")
    end
  end

  def register(user, passw, device_name) do
    body = %{
      "auth" => %{
        "type" => "m.login.password"
      },
      "initial_device_display_name" => device_name,
      "password" => passw,
      "username" => user
    }
    body = Poison.encode!(body)

    case HTTPoison.post("#{@base_server}/register", body, @base_headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts("Request successful. Response body: #{body}")

      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        IO.puts("Request failed with status code: #{status}. Response body: #{body}")

      {:error, error} ->
        IO.puts("Request failed with error: #{inspect(error)}")

      _ ->
        IO.puts("Unexpected response body: #{inspect(body)}")
    end
  end

  def get_token() do
    body = ""

    case HTTPoison.post("#{@base_server}/_matrix/client/r0/register?kind=guest", body, @base_headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        IO.puts("Request successful. Response body: #{response_body}")

      {:ok, %HTTPoison.Response{status_code: status, body: response_body}} ->
        IO.puts("Request failed with status code: #{status}. Response body: #{response_body}")

      {:error, error} ->
        IO.puts("Request failed with error: #{inspect(error)}")
    end
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
