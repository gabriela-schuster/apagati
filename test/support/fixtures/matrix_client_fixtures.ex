defmodule Apagati.MatrixClientFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Apagati.MatrixClient` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Apagati.MatrixClient.create_room()

    room
  end
end
