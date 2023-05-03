defmodule Gamco.Component do
  use Phoenix.Component

  import Phoenix.HTML, only: [raw: 1]

  def javascript_tags(assigns) do
    ~H"""
    <script async src={"#{@gtag_manager_url}?id=#{@tag_id}"}></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag("js", new Date());
      gtag("config", "<%= @tag_id %>", <%= raw(@data) %>);
    </script>
    """
  end

  def tag(assigns) do
    ~H"""
    <script>
      gtag("<%= @type %>", "<%= @event %>", <%= raw(@dimensions) %>)
    </script>
    """
  end
end
