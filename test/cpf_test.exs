defmodule CpfTest do
    use ExUnit.Case
    doctest Cpf

    test "create new cpf by integer" do
        assert %Cpf{number: 1} == Cpf.new(1)
    end
    test "crate new cpf by String" do
        assert %Cpf{number: 01} == Cpf.new("01")
    end

    test "return cpf as list" do
        assert [1,2,3,4] ==  Cpf.new(1234) |> Cpf.Transform.to_list
    end

    test "cpf é valido" do
        assert Cpf.is_valid(28191575809) == {:ok, "Válido"}
    end

    test "cpf é valido como string" do
        assert Cpf.is_valid("07834965085") == {:ok, "Válido"}
    end

    test "cpf não é valido com numeros iguais zeros" do
        refute Cpf.is_valid("00000000000") == {:ok, "Válido"}
    end

    test "cpf não é valido com numeros iguais uns" do
        refute Cpf.is_valid("11111111111") == {:ok, "Válido"}
    end

    test "cpf 078.349.650-85 é válido" do
        assert Cpf.is_valid(7834965085) == {:ok, "Válido"}
    end

    test "cpf é não é valido" do
        refute Cpf.is_valid(28191575801) == {:ok, "Cpf é válido"}
    end

    test "cpf inválido, com mensagem de erro correta" do
        assert Cpf.is_valid(28191575801) == {:error, "Cpf é inválido", 28191575801}
    end

    test "Gerar digito verificador" do
        assert Cpf.gerar_digito(281915758) == "09"
    end

end
