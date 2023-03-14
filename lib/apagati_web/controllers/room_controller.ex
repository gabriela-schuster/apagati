defmodule ApagatiWeb.RoomController do
  use ApagatiWeb, :controller

  alias Apagati.MatrixClient
  alias Apagati.MatrixClient.Room

  def index(conn, _params) do
    token = MatrixClient.get_token()
    IO.inspect(token)
    rooms = MatrixClient.list_rooms()
    render(conn, :index, rooms: rooms)
  end

  def new(conn, _params) do
    changeset = MatrixClient.change_room(%Room{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    case MatrixClient.create_room(room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room created successfully.")
        |> redirect(to: ~p"/rooms/#{room}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    {:ok, matrix_client} = Client.new()
    room = Client.Room.get(matrix_client, id)

    # room = MatrixClient.get_room!(id)

    render(conn, :show, room: room)
  end

  def edit(conn, %{"id" => id}) do
    room = MatrixClient.get_room!(id)
    changeset = MatrixClient.change_room(room)
    render(conn, :edit, room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = MatrixClient.get_room!(id)

    case MatrixClient.update_room(room, room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> redirect(to: ~p"/rooms/#{room}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, room: room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = MatrixClient.get_room!(id)
    {:ok, _room} = MatrixClient.delete_room(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: ~p"/rooms")
  end
end
