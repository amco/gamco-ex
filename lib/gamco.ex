defmodule Gamco do
  @moduledoc """
  Documentation for `Gamco`.
  """

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      alias Gamco.{Secure, Builder}

      @otp_app Keyword.fetch!(opts, :otp_app)

      def ga_javascript_tags(opts \\ []) do
        tag_id = Keyword.get(opts, :tag_id, ga_tag_id())
        if ga_active?(), do: Builder.javascript_tags(tag_id, opts)
      end

      def ga_tag(type, event, opts \\ []) do
        if ga_active?(), do: Builder.tag(type, event, opts)
      end

      def ga_secure(value) when is_nil(value), do: nil
      def ga_secure(value), do: secure_module().call(value)

      defp ga_active? do
        config() |> Keyword.get(:active)
      end

      defp ga_tag_id do
        config() |> Keyword.get(:tag_id)
      end

      defp secure_module do
        config() |> Keyword.get(:secure_module, Secure)
      end

      defp config do
        Application.fetch_env!(@otp_app, __MODULE__)
      end
    end
  end
end
