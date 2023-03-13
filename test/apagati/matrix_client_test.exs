defmodule Apagati.MatrixClientTest do
  use Apagati.DataCase

  alias Apagati.MatrixClient

  describe "rooms" do
    alias Apagati.MatrixClient.Room

    import Apagati.MatrixClientFixtures

    @invalid_attrs %{title: nil}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert MatrixClient.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert MatrixClient.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Room{} = room} = MatrixClient.create_room(valid_attrs)
      assert room.title == "some title"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MatrixClient.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Room{} = room} = MatrixClient.update_room(room, update_attrs)
      assert room.title == "some updated title"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = MatrixClient.update_room(room, @invalid_attrs)
      assert room == MatrixClient.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = MatrixClient.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> MatrixClient.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = MatrixClient.change_room(room)
    end
  end
end
