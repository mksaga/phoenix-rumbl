defmodule RumblWeb.Auth do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Rumbl.Accounts.get_user(user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    # use the "assigns" field in Plug.Conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    # protect us from fixation attacks: send session cookie to client with new identifier
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

end
