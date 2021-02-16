defmodule Stack do
  use GenServer

  def start_link(_ \\ []) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:gerar}, _from, state) do
    {:reply, Cpf.gerar(), state}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end

  def gerar() do
    GenServer.call(__MODULE__, {:gerar})
  end
end
