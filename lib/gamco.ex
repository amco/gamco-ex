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
      Generates scripts to initialize Google Analytics.

      ## Parameters

        - `opts` - A map or keyword list of options to configure the GA scripts.
          - `:nonce` - A string representing a nonce value for CSP.
          - Additional options can be passed and will be sent to GA.

      ## Examples

          iex> ga_javascript_tags(nonce: "random")
          <script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXX"></script>
          <script nonce>
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag("js", new Date());
            gtag("config", "G-XXXXXXXXX", {});
          </script>

      """
      @spec ga_javascript_tags(map() | keyword()) :: String.t() | nil
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
      Generates gtag tag for custom events.

      ## Parameters

        - `type` - A string representing the type of gtag call (e.g., "event").
        - `event` - A string representing the event name (e.g., "product_view").
        - `opts` - A map or keyword list of additional parameters to send with the event.
          - `:nonce` - A string representing a nonce value for CSP.
          - Additional options can be passed and will be sent to GA.

      ## Examples

          iex> ga_tag("event", "product_view", product_id: 1, nonce: "r@ndom")
          <script nonce>
            gtag("event", "product_view", {"product_id": 1})
          </script>

      """
      @spec ga_tag(String.t(), String.t(), map() | keyword()) :: String.t() | nil
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
      Secures data in order to be sent to Google Analytics.

      ## Parameters

        - `value` - The value to be secured.

      ## Examples

          iex> ga_secure("foo")
          "acbd18db4cc2f85cedef654fccc4a4d8"

          iex> ga_secure(nil)
          nil

      """
      @spec ga_secure(String.t() | nil) :: String.t() | nil
      def ga_secure(nil), do: nil
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
