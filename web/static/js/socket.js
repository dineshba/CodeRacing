// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

let resultContainer = document.querySelector("#results")
var number_of_challenges = 0;
var users = new Array();

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("code_racing:track", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("no_of_challenges", payload => {
  number_of_challenges = payload.body.number_of_challenges
})

channel.on("next_challenge", payload => {
  let index = users.findIndex(function(value) {
    return value.id === payload.body.key
  })
  users[index].challenge = payload.body.challenge_id
  update(users)
})

channel.on("new_player", payload => {
  users.push({"name": payload.body.player_name, "challenge": payload.body.challenge_id, "id": payload.body.key})
  update(users)
})

var update = function(users) {
  resultContainer.innerText = ""
  let header = document.createElement("div");
  let start_point = document.createElement("p");
  start_point.innerText = "Start Point"
  let flag_element = document.createElement("IMG");
  flag_element.src = `/images/checkflag.png`;
  flag_element.width = 50
  flag_element.height = 50
  flag_element.style.marginLeft = number_of_challenges * 100 + 'px';
  header.appendChild(start_point)
  header.appendChild(flag_element)
  resultContainer.appendChild(header)
  let count = 0
  users.forEach(function(user) {
    let user_element = document.createElement("div");
    let user_image = document.createElement("IMG");
    let user_name = document.createElement("div");
    user_image.src = `/images/car${(count % 8) + 1}.png`;
    user_image.width = 50
    user_image.height = 50
    count = count + 1
    user_name.innerText = user.name
    user_element.appendChild(user_image)
    user_element.appendChild(user_name)
    user_element.style.marginLeft = (user.challenge - 1) * 100 + 'px'
    resultContainer.appendChild(user_element)
  });
}

export default socket
