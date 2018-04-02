# CodeRacing

### To Play
  * Register by `curl -X POST -d '{"user": {"name": "yourName"}}' -H "Content-Type:application/json" localhost:4000/register`
  * You will get a secret_key in the above response. Use that for the successive requests
  * To see the challenge for you(racer), `curl localhost:4000/challenge -H "username: yourName" -H "key: secret_key"`
  * To get the random input from server, `curl localhost:4000/challenge/input -H "username: yourName" -H "key: secret_key"`
  * To post your output, `curl -X POST -d '{"output": output_body_in_sample_response}' localhost:4000/challenge/output -H "username: yourName" -H "key: secret_key" -H "Content-Type: application/json"`
  * **Note:** Inputs are random and time difference between input and output requests should be less than `2 seconds`

To start code racer in your local:

  * Clone the repo
  * Install elixir and erlang (refer version in .tool-versions file)
  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) in your browser to see the progress of the race.
