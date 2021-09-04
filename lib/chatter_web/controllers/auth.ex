defmodule ChatterWeb.Auth do

    #Imports only check password(checkpw) and dummy check password(dummy_checkpw)
    import Comeonin.Pbkdf2, only: [checkpw: 2, dummy_checkpw: 0]
    import Plug.Conn

    def login(conn, user) do
        conn
        |> Guardian.Plug.sign_in(user, :access)
    end

    def login_with(conn, email, pass, opts) do
        repo = Keyword.fetch!(opts, :repo)
        #Specifies the module and field to get record by
        user = repo.get_by(Chatter.User, email: email)

        cond do
            user && checkpw(pass, user.encrypt_pass) -> 
                {:ok, login(conn, user)}
            user ->
                {:error, :unauthorized, conn}
            true ->
                dummy_checkpw()
                {:error, :not_found, conn}
        end
    end
end