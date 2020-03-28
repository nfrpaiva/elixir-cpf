defmodule App do
  use Application

  def start(_type, _args) do
    Cpf.Supervisor.start_link
  end

end
