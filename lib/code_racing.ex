defmodule CodeRacing do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    challenges = [%{name: "Array size", examples: ["[1,2,3] --> 3", "[] --> 0"], problem_set: [%{input: [1, 2, 3, 4, 5], output: 5}, %{input: [1, 2, 3, 4, 5, 6, 7], output: 7}, %{input: [1, 2], output: 2}]},
                  %{name: "Array average", examples: ["[1,2,3] --> 2", "[] --> 0"], problem_set: [%{input: [1, 2, 3, 4, 5], output: 3}]},
                  %{name: "Array max", examples: ["[1,2,3] --> 3", "[] --> nil"], problem_set: [%{input: [1, 2, 3, 4, 5], output: 5}]},
                  %{name: "Array min", examples: ["[1,2,3] --> 1", "[] --> nil"], problem_set: [%{input: [1, 2, 3, 4, 5], output: 1}]}]
    children = [
      # Start the endpoint when the application starts
      supervisor(CodeRacing.Endpoint, []),
      worker(CodeRacing.Challenges, [challenges]),
      worker(CodeRacing.PlayersSupervisor, [[]]),
      # Start your own worker by calling: CodeRacing.Worker.start_link(arg1, arg2, arg3)
      # worker(CodeRacing.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CodeRacing.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CodeRacing.Endpoint.config_change(changed, removed)
    :ok
  end
end
