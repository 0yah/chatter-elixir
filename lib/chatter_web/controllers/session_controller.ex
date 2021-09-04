defmodule ChatterWeb.SessionController do
    use ChatterWeb, :controller
  
    alias Chatter.Repo
    import ChatterWeb.Auth
    require Logger

    def new(conn, _params) do
      render(conn, "new.html")
    end


    #Login function
    def create(conn, %{"session" => %{"email" => user, "password" => password}}) do
        case login_with(conn, user, password, repo: Repo) do
            {:ok, conn} ->
                _logged_user = Guardian.Plug.current_resource(conn)
                conn
                |> put_flash(:info, "logged in!")
                #Send the logged user to the homepage
                |> redirect(to: Routes.page_path(conn, :index))
            {:error, reason, conn} -> 
                Logger.info(reason)
                conn
                |> put_flash(:error, "Wrong username/password")
                |> render("new.html")
        end
    end

    #Log out function
    def delete(conn, _) do
        conn
        |> Guardian.Plug.sign_out
        |> redirect(to: "/")
    end
  end
  