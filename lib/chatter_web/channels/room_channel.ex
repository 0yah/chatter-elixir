defmodule ChatterWeb.RoomChannel do
    use ChatterWeb, :channel
    alias ChatterWeb.Presence
    require Logger
    

    """

    self() - user
    :after_join atom is corresponded with the callback function handle_info

    """
    def join("room:lobby", _, socket) do
        send self(), :after_join
        {:ok, socket}
    end


    # Callback function
    def handle_info(:after_join, socket) do
        """

        Track at the socket 
        Assign the user then track when the user logged into the socket

        """
        Presence.track(socket, socket.assigns.user, %{
            online_at: System.os_time(:millisecond),
            typing: false
        })

        """
        
        Send it back to the socket and update the list

        """
        push socket, "presence_state", Presence.list(socket)
        {:noreply, socket}
    end


    """
    
    Event handler for message:new

    Broadcasts the messsage to everyone

    """
    def handle_in("message:new", message, socket) do

        Logger.info(message)

        broadcast! socket, "message:new", %{
            user: socket.assigns.user,
            body: message,
            timestamp: System.os_time(:millisecond)
        }

        {:noreply, socket}
    end

    def handle_in("message:typing", _message, socket) do

        Logger.info("#{socket.assigns.user} is typing...")
        

        broadcast! socket, "message:typing", %{
            user: socket.assigns.user,
            typing: true,
            timestamp: System.os_time(:millisecond)
        }

        {:noreply, socket}
    end


end