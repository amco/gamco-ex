defmodule Gamco.ComponentTest do
  use ExUnit.Case, async: true

  import Phoenix.LiveViewTest

  alias Gamco.Component

  describe "javascript_tags/1" do
    test "returns script tags for GA setup" do
      assigns =
        %{}
        |> Map.put(:tag_id, "G-XXXXXXXXX")
        |> Map.put(:data, Jason.encode!(%{}))
        |> Map.put(:gtag_manager_url, "https://google.com")

      html = ~S"""
      <script async src="https://google.com?id=G-XXXXXXXXX"></script>
      <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag("js", new Date());
        gtag("config", "G-XXXXXXXXX", {});
      </script>
      """

      rendered =
        (&Component.javascript_tags/1)
        |> render_component(assigns)

      assert rendered == String.trim(html)
    end

    test "returns script tags with nonce" do
      assigns =
        %{}
        |> Map.put(:nonce, "random")
        |> Map.put(:tag_id, "G-XXXXXXXXX")
        |> Map.put(:data, Jason.encode!(%{}))
        |> Map.put(:gtag_manager_url, "https://google.com")

      html = ~S"""
      <script async src="https://google.com?id=G-XXXXXXXXX"></script>
      <script nonce="random">
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag("js", new Date());
        gtag("config", "G-XXXXXXXXX", {});
      </script>
      """

      rendered =
        (&Component.javascript_tags/1)
        |> render_component(assigns)

      assert rendered == String.trim(html)
    end
  end

  describe "tag/1" do
    test "returns script tag for custom GA events with nonce" do
      assigns =
        %{}
        |> Map.put(:nonce, "random")
        |> Map.put(:type, "event")
        |> Map.put(:event, "product_view")
        |> Map.put(:dimensions, Jason.encode!(%{}))

      html = ~S"""
      <script nonce="random">
        gtag("event", "product_view", {})
      </script>
      """

      rendered =
        (&Component.tag/1)
        |> render_component(assigns)

      assert rendered == String.trim(html)
    end
  end
end
