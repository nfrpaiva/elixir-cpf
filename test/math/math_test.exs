defmodule Cpf.MathTest do
  use ExUnit.Case

  test "divirir 10 por 3 em array" do
    assert Cpf.Math.split_div(10, 3) == [4, 3, 3]
  end

  test "dividir 100 por 3 em array" do
    assert Cpf.Math.split_div(100, 3) == [34, 33, 33]
  end

  test "dividir 10 /100" do
    assert Cpf.Math.split_div(10, 1000) == [10]
  end
end
