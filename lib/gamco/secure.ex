defmodule Gamco.Secure do
  def call(value) do
    :crypto.hash(:md5 , value)
    |> Base.encode16()
    |> String.downcase()
  end
end
