defmodule Cpf do
  @moduledoc """
  Documentation for `Cpf`.
  """
  @doc """
  Hello world.

  ## Examples

      iex> Cpf.is_valid("07834965085")
      {:ok, "Válido"}

      iex> Cpf.is_valid("07834965086")
      {:error, "Cpf é inválido", 7834965086}

  """

  @enforce_keys [:number]
  defstruct number: Integer

  def new(value) when is_number(value) do
    %Cpf{number: value}
  end

  def new(value) when is_binary(value) do
    %Cpf{number: String.to_integer(value)}
  end

  defprotocol Transform do
    def to_list(integer)
  end

  defimpl Cpf.Transform, for: Cpf do
    def to_list(cpf), do: Integer.digits(cpf.number)
  end

  def is_valid(cpf) when is_binary(cpf) do
    is_valid(String.to_integer(cpf))
  end

  def is_valid(cpf) when is_number(cpf) do
    numero = get_numero(cpf)
    digito = gerar_list_digito(numero)
    numero_e_digito = numero ++ digito
    novo_cpf = list_to_integer(numero_e_digito)

    if cpf == novo_cpf && !todos_digito_sao_iguais(numero_e_digito) do
      {:ok, "Válido"}
    else
      {:error, "Cpf é inválido", cpf}
    end
  end

  def gerar_digito(numero) when is_binary(numero) do
    String.to_integer(numero) |> gerar_digito
  end

  def gerar_digito(numero) when is_number(numero) do
    numero = Integer.digits(numero)
    digito = gerar_list_digito(numero)

    Enum.map(digito, fn x -> Integer.to_string(x) end)
    |> Enum.reduce(fn b, a -> a <> b end)
  end

  defp todos_digito_sao_iguais(list) when is_list(list) do
    [head | _] = list
    list_filtrada = Enum.filter(list, fn x -> x == head end)
    length(list) == length(list_filtrada)
  end

  defp gerar_list_digito(numero) when is_list(numero) do
    numero_mais_j = numero ++ [resto(numero)]
    numero_mais_k = numero_mais_j ++ [resto(numero_mais_j)]
    {_, digito} = Enum.split(numero_mais_k, -2)
    digito
  end

  defp get_numero(numero) when is_number(numero) do
    numero_list = Integer.digits(numero)
    Enum.take(numero_list, length(numero_list) - 2)
  end

  defp list_to_integer(list) when is_list(list) do
    Enum.map(list, fn x -> Integer.to_string(x) end)
    |> Enum.reduce(fn b, a -> a <> b end)
    |> String.to_integer()
  end

  defp resto(numero) do
    Enum.reverse(numero)
    |> Enum.map_reduce(2, fn x, acc -> {x * acc, acc + 1} end)
    |> elem(0)
    |> Enum.reduce(fn a, b -> a + b end)
    |> rem(11)
    |> digito
  end

  defp digito(resto) do
    if resto <= 1 do
      0
    else
      11 - resto
    end
  end
end
