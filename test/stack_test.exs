defmodule StackTest do
  use ExUnit.Case, async: true

  #setup do
    #registry = start_supervised!(Stack)
    #%{registry: registry}
  #end

  test "cpf gerado aleatório" do
      assert is_binary(Stack.gerar_cpf)
  end

end
