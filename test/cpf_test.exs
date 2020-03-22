defmodule CpfTest do
  use ExUnit.Case
  doctest Cpf

  @cpf_ok {:ok, "Válido"}
  @cpf_nao_ok {:error, "Cpf é inválido", 28_191_575_801}

  test "create new cpf by integer" do
    assert %Cpf{number: 1} == Cpf.new(1)
  end

  test "crate new cpf by String" do
    assert %Cpf{number: 01} == Cpf.new("01")
  end

  test "return cpf as list" do
    assert [1, 2, 3, 4] == Cpf.new(1234) |> Cpf.Transform.to_list()
  end

  test "cpf é valido" do
    assert Cpf.is_valid(28_191_575_809) == @cpf_ok
  end

  test "cpf é valido como string" do
    assert Cpf.is_valid("07834965085") == @cpf_ok
  end

  test "cpf não é valido com numeros iguais zeros" do
    refute Cpf.is_valid("00000000000") == @cpf_ok
  end

  test "cpf não é valido com numeros iguais uns" do
    refute Cpf.is_valid("11111111111") == @cpf_ok
  end

  test "cpf 078.349.650-85 é válido" do
    assert Cpf.is_valid(7_834_965_085) == @cpf_ok
  end

  test "cpf é não é valido" do
    refute Cpf.is_valid(28_191_575_801) == @cpf_ok
  end

  test "cpf inválido, com mensagem de erro correta" do
    assert Cpf.is_valid(28_191_575_801) == @cpf_nao_ok
  end

  test "Gerar digito verificador" do
    assert Cpf.gerar_digito(281_915_758) == "09"
  end
end
