defmodule Gamco do
  @moduledoc """
  Documentation for `Gamco`.
  """

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      alias Gamco.{Secure, Component}

      @otp_app Keyword.fetch!(opts, :otp_app)
      @gtag_manager_url "https://www.googletagmanager.com/gtag/js"

      @doc """
      This function generates scripts to initialize Google Analytics.

      ## Examples

          iex> ga_javascript_tags()
          <script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXX"></script>
          <script>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag("js", new Date());
            gtag("config", "G-XXXXXXXXX", {});
          </script>

          iex> ga_javascript_tags(nonce: "random")
          <script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXX"></script>
          <script nonce>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag("js", new Date());
            gtag("config", "G-XXXXXXXXX", {});
          </script>
      """
      def ga_javascript_tags(opts \\ %{})

      def ga_javascript_tags(opts) when is_list(opts) do
        opts
        |> Enum.into(%{})
        |> ga_javascript_tags()
      end

      def ga_javascript_tags(opts) when is_map(opts) do
        {nonce, opts} = Map.pop(opts, :nonce)

        if ga_active?() do
          %{}
          |> Map.put(:tag_id, ga_tag_id())
          |> Map.put(:nonce, nonce)
          |> Map.put(:data, Jason.encode!(opts))
          |> Map.put(:gtag_manager_url, @gtag_manager_url)
          |> Component.javascript_tags()
        end
      end

      @doc """
      This function generates gtag tag for custom events.

      ## Examples

          iex> ga_tag("event", "product_view", product_id: 1, nonce: "r@ndom")
          <script nonce>
            gtag("event", "product_view", {"product_id": 1})
          </script>

      """
      def ga_tag(type, event, opts \\ %{})

      def ga_tag(type, event, opts) when is_list(opts) do
        ga_tag(type, event, Enum.into(opts, %{}))
      end

      def ga_tag(type, event, opts) when is_map(opts) do
        {nonce, opts} = Map.pop(opts, :nonce)

        if ga_active?() do
          %{}
          |> Map.put(:type, type)
          |> Map.put(:nonce, nonce)
          |> Map.put(:event, event)
          |> Map.put(:dimensions, Jason.encode!(opts))
          |> Component.tag()
        end
      end

      @doc """
      This function secure data in order to be send to GA.

      ## Examples

          iex> ga_secure("foo")
          "acbd18db4cc2f85cedef654fccc4a4d8"

          iex> ga_secure(nil)
          nil

      """
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
