defmodule Gamco.Component do
  use Phoenix.Component

  import Phoenix.HTML, only: [raw: 1]

  attr(:gtag_manager_url, :string, required: true)
  attr(:tag_id, :string, required: true)
  attr(:data, :string, required: true)
  attr(:nonce, :string, default: nil)

  def javascript_tags(assigns) do
    ~H"""
    <script async src={"#{@gtag_manager_url}?id=#{@tag_id}"}></script>
    <script nonce={@nonce}>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag("js", new Date());
      gtag("config", "<%= @tag_id %>", <%= raw(@data) %>);
    </script>
    """
  end

  attr(:type, :string, required: true)
  attr(:event, :string, required: true)
  attr(:dimensions, :string, required: true)
  attr(:nonce, :string, default: nil)

  def tag(assigns) do
    ~H"""
    <script nonce={@nonce}>
      gtag("<%= @type %>", "<%= @event %>", <%= raw(@dimensions) %>)
    </script>
    """
  end
end
