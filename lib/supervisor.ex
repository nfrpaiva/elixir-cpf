defmodule Cpf.Supervisor do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: Cpf.Supervisor)
  end

  @impl true
  def init(_) do
    children = [
      {Stack, name: Stack}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
