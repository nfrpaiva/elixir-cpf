defmodule Cpf.Math do
  def split_div(dividendo, divisor) do
    quociente = div(dividendo, divisor)

    list =
      1..divisor
      |> Enum.map(fn _x -> quociente end)

    [head | tail] = list

    [head + rem(dividendo, divisor)] ++ tail
  end
end
