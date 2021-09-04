defmodule ChatterWeb.UserController do
    use ChatterWeb, :controller

    #The User Model
    alias Chatter.User
    alias Chatter.Repo

    def index(conn, _params) do
        users = Repo.all(User)
        render(conn, "index.html", users: users )
    end


    def show(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        render(conn, "show.html", user: user)
    end

    #GET
    def new(conn, _params) do
    
        #Refer to the changeset function in the model
        #Initialize an empty user 
        changeset = User.changeset(%User{})
        render(conn, "new.html", changeset: changeset)
    end

    #POST
    def create(conn, %{"user" => user_params}) do


        changeset = User.reg_changeset(%User{}, user_params)

        case Repo.insert(changeset) do

            #If ok is returned add a message and redirect to the homepage
            {:ok, _user} -> 
                conn
                |> put_flash(:info, "User created successfully.")
                |> redirect(to: Routes.user_path(conn, :index))
            {:error, changeset} ->
                render(conn, "new.html", changeset: changeset)

        end
    end

    #GET
    def edit(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        changeset = User.changeset(user)
        render(conn, "edit.html", user: user, changeset: changeset)
        
    end

    def update(conn, %{"id" => id, "user" => user_params}) do
    
        user = Repo.get!(User, id)
        changeset = User.reg_changeset(user, user_params)

        case Repo.update(changeset) do
            {:ok, user} ->
                conn
                |> put_flash(:info, "User updated successfully.")
                |> redirect(to: Routes.user_path(conn, :show, user))
            {:error, changeset} ->
                render(conn, "edit.html", user: user, changeset: changeset)
        end
    end

    def delete(conn, %{"id" => id}) do
        user = Repo.get!(User, id)
        Repo.delete!(user)

        conn
        |> put_flash(:info, "User deleted successfully")
        |> redirect(to: Routes.user_path(conn, :index))
    end


end

