defmodule ApptestTest do
  use ExUnit.Case
  doctest Apptest

  test "greets the world" do
    assert Apptest.hello() == :world
  end
  test "cpf é valido" do
    assert Apptest.is_valid(28191575809) == {:ok, "Válido"}
  end
  test "cpf é não é valido" do
    refute Apptest.is_valid(28191575801) == {:ok, "Cpf é válido"}
  end

  test "cpf inválido, com mensagem de erro correta" do
    assert Apptest.is_valid(28191575801) == {:error, "Cpf é inválido", 28191575801}
  end

end
