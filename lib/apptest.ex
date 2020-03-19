defmodule Apptest do
  @moduledoc """
  Documentation for `Apptest`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Apptest.hello()
      :world

  """
  def hello do
    :world
  end
  
  def is_valid(cpf \\ 28191575809) do
    
    numero = integer_to_list(cpf)
    
    numero_mais_j = numero ++ [resto(numero, 10)]
    numero_mais_k = numero_mais_j ++ [resto(numero_mais_j, 11)]
    novo_cpf = list_to_integer(numero_mais_k)
    
    if cpf == novo_cpf do
      {:ok, "Válido"}
    else 
      {:error, "Cpf é inválido", cpf}
    end
      
  end

  defp integer_to_list(numero) when is_number(numero) do
    {numero,_} = (Integer.to_string(numero) 
      |> String.split("", trim: true) 
      |> Enum.map(fn i -> {int,_} = Integer.parse(i); int end))  
      |> Enum.split(-2)
      numero
  end

  defp list_to_integer(list) when is_list(list) do
    Enum.map(list, fn x -> Integer.to_string(x) end) 
      |> Enum.reduce(fn b,a -> a <> b end)
      |> String.to_integer
  end

  defp resto(numero, multiplicador) do 
    Enum.map_reduce(numero,multiplicador, fn x, acc -> {x*acc, acc-1} end) 
      |> elem(0) 
      |> Enum.reduce(fn a,b -> a+b end) 
      |> rem(11) 
      |> digito
  end

  defp digito(resto) do
    if resto <=1 do
      0
    else
      11 - resto
    end
  end

end
