defmodule BackendWeb.InviteController do
  use BackendWeb, :controller

  alias Backend.Invites
  alias Backend.Invites.Invite

  alias BackendWeb.Plugs
  plug Plugs.RequireAuth when action
                              in [:create, :update]

  action_fallback BackendWeb.FallbackController

  def index(conn, _params) do
    invites = Invites.list_invites()
    render(conn, "index.json", invites: invites)
  end

  def create(conn, %{"invite" => invite_params}) do
    with {:ok, %Invite{} = invite} <- Invites.create_invite(invite_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.invite_path(conn, :show, invite))
      |> render("show.json", invite: invite)
    end
  end

  def show(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)
    render(conn, "show.json", invite: invite)
  end

  def update(conn, %{"id" => id, "invite" => invite_params}) do
    IO.inspect id
    IO.inspect invite_params
    invite = Invites.get_invite!(id)

    with {:ok, %Invite{} = invite} <- Invites.update_invite(invite, invite_params) do
      render(conn, "show.json", invite: invite)
    end
  end

  def delete(conn, %{"id" => id}) do
    invite = Invites.get_invite!(id)

    with {:ok, %Invite{}} <- Invites.delete_invite(invite) do
      send_resp(conn, :no_content, "")
    end
  end

  def by_event(conn, %{"id" => id}) do
    invites = Invites.by_event(id)
    render(conn, "index.json", invites: invites)
  end
end
