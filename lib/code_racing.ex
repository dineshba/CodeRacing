defmodule CodeRacing do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    challenges = [%{name: "Start silly, acceleration for the count. Given list of products, return back the count and you get a furious start",
                    sample_input: %{"input": [%{
      "name": "Apple iPhone 6s 128GB Space Grey Refurbished",
      "price": 1737
    }, %{
    "name": "Nokia 3220",
    "price": 999
    }, %{
    "name": "iBall Slide Brace-X1 Mini 16GB",
    "price": 1737
    },
    %{
      "name": "Dekor World POLKA DOT DIWAN SET- PACK OF 8 PCS",
      "price": 786
    }, %{
    "name": "Swayam Yellow Colour Floral Printed Eyelet Door Curtain - Window Curtain",
    "price": 654
    }]},
    sample_output: %{
      "output": 6
    },
    problem_set: [%{input: [%{
      "name": "Xiaomi Redmi 3S Prime 32GB 3GB",
      "price": 1737
    }, %{
    "name": "Sennheiser CX 180 Street II In-Ear Headphone",
    "price": 649
    }, %{
    "name": "Honor AP007 13000 mAH Power Bank Grey",
    "price": 869
    }, %{
    "name": "Homefab India Set of 2 Royal Silky Aqua Blue Designer Curtains (HF158)",
    "price": 629
    }, %{
    "name": "Homefab India Set of 2  Beautiful Marble Plain Black Curtains (HF342)",
    "price": 499
    }, %{
    "name": "Set of 2 - measuring cups & measuring spoon",
    "price": 350
    }], output: 6}]}
  ]
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
