defmodule Cpf.Math do
  def split_div(dividendo, divisor) when dividendo < divisor do
    [dividendo]
  end

  def split_div(dividendo, divisor) do
    [head | tail] =
      1..divisor
      |> Enum.map(fn _x -> div(dividendo, divisor) end)

    [head + rem(dividendo, divisor)] ++ tail
  end
end
