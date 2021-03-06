defmodule Cpf do
  @moduledoc """
  Documentation for `Cpf`.
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

  @doc """
  Verifica se um cpf é válido.

  ## Examples

      iex> Cpf.is_valid("07834965085")
      {:ok, "Válido"}

      iex> Cpf.is_valid("07834965086")
      {:error, "Cpf é inválido", "07834965086"}

      iex> Cpf.is_valid("00000000000")
      {:error, "Cpf é inválido", "00000000000"}

      iex> Cpf.is_valid(Cpf.new(07834965085))
      {:ok, "Válido"}
  """
  def is_valid(cpf)

  def is_valid(%{number: value}) do
    is_valid(value)
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
      {:error, "Cpf é inválido", Integer.to_string(cpf) |> String.pad_leading(11, "0")}
    end
  end

  @doc """
  Gera o digito verificador

  ## Examples
      iex> Cpf.gerar_digito("078349650")
      "85"
      iex> Cpf.gerar_digito("999999999")
      {:erro, "Todos os dígitos não podem ser iguais"}
  """

  @spec gerar_digito(binary | integer) :: String.t()
  def gerar_digito(numero)

  def gerar_digito(numero) when is_binary(numero) do
    String.to_integer(numero) |> gerar_digito
  end

  def gerar_digito(numero) when is_number(numero) do
    numero = Integer.digits(numero)

    if todos_digito_sao_iguais(numero) do
      {:erro, "Todos os dígitos não podem ser iguais"}
    else
      digito = gerar_list_digito(numero)
      Enum.map(digito, fn x -> Integer.to_string(x) end) |> Enum.reduce(fn b, a -> a <> b end)
    end
  end

  @doc """
  Gera um número de cpf aleatório
  """
  def gerar() do
    rand_numero = Enum.random(1..999_999_999)

    if todos_digito_sao_iguais(Integer.digits(rand_numero)) do
      gerar()
    else
      numero = rand_numero |> Integer.to_string()
      (numero <> gerar_digito(numero)) |> String.pad_leading(11, "0")
    end
  end

  def gerar(quantidade_cpfs, processos \\ 1)

  def gerar(quantidade_cpfs, processos) when is_integer(quantidade_cpfs) and processos > 1 do
    Cpf.Math.split_div(quantidade_cpfs, processos)
    |> Enum.map(fn quantidade_cpfs -> Task.async(fn -> gerar(quantidade_cpfs) end) end)
    |> Enum.map(fn pid -> Task.await(pid, 60 * 1000 * 10) end)
    |> Enum.reduce(fn a, b -> a ++ b end)
  end

  def gerar(quantidade_cpfs, processos) when is_integer(quantidade_cpfs) and processos == 1 do
    Enum.map(1..quantidade_cpfs, fn _ -> Cpf.gerar() end)
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

  defp digito(resto) when resto <= 1, do: 0
  defp digito(resto), do: 11 - resto
end
