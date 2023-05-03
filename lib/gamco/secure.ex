defmodule Gamco.Secure do
  @moduledoc """
  This module provides the default function to secure
  any sensitive information in order to be send to GA.
  """

  @doc """
  This function hashes the value passed as argument
  using md5 hexadecimal and downcases the resulting
  string.

  ## Examples

      iex> Gamco.Secure.call("foo")
      "acbd18db4cc2f85cedef654fccc4a4d8"

  """
  def call(value) do
    :crypto.hash(:md5 , value)
    |> Base.encode16()
    |> String.downcase()
  end
end
