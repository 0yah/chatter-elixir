defmodule ChatterWeb.Token do
    use ChatterWeb, :controller

    def unathenticated(conn, _params) do
        conn
        |> put_flash(:error, "You must be signed in!")
        |> redirect(to: Routes.session_path(conn, :new))

    end

    def unauthorized(conn, _params) do
        conn
        |> put_flash(:error, "You must be signed in!")
        |> redirect(to: Routes.session_path(conn, :new))
    end
    
end