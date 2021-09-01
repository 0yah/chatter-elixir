// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
import { Socket, Presence } from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"


//gets the user from the conn.params["user"] which is referenced using the ID tag with value of "user"
let user = document.getElementById("user").innerText;

let socket = new Socket("/socket", {
    params: { user }
});

socket.connect();


let presences = {}

let formattedTimestamp = (Ts) => {

    let date = new Date(Ts);
    return date.toLocaleString();
}

let listBy = (user, { metas }) => {

    console.log(metas);
    return {

        user,
        onlineAt: formattedTimestamp(metas[0].online_at)
    }
};


//get the user list element
let userList = document.getElementById("userList");

let render = presences => {

    return userList.innerHTML = Presence.list(presences, listBy).map(presence => `
    
    <li>
    ${presence.user}
    <br/>
    <small>online since ${presence.onlineAt}</small>
    </li>

    `).join("");

}

//Channel defined in channels/room_channel.ex
let room = socket.channel("room:lobby");
/*

When the server send us the state of everyone who is online which happens when we first connect or disconnect
The event will send everything to the html

*/
room.on("presence_state", state =>{

    presences = Presence.syncState(presences, state);
    render(presences);

});


room.on("presence_diff", diff =>{

    presences = Presence.syncDiff(presences, diff);
    render(presences);

});

room.join();


let messageInput = document.getElementById("newMessage")
messageInput.addEventListener("keypress", (e)=>{

    /*
    If enter is pressed and the input is not blank
    */
    if(e.keyCode == 13 && e.target.value != ""){
        room.push("message:new", e.target.value);
        messageInput.value = "";
    }
});