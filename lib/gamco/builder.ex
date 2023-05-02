defmodule Gamco.Builder do
  import Phoenix.Component

  @gtag_manager_url "https://www.googletagmanager.com/gtag/js"

  def javascript_tags(tag_id, opts \\ []) do
    data =
      opts
      |> Enum.into(%{})
      |> Jason.encode!()

    assigns =
      %{}
      |> Map.put(:data, data)
      |> Map.put(:tag_id, tag_id)
      |> Map.put(:gtag_manager_url, @gtag_manager_url)

    ~H"""
    <script async src={"#{@gtag_manager_url}?id=#{@tag_id}"}></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag("js", new Date());
      gtag("config", "<%= @tag_id %>", <%= Phoenix.HTML.raw(@data) %>);
    </script>
    """
  end

  def tag(type, event, opts \\ []) do
    dimensions =
      opts
      |> Enum.into(%{})
      |> Jason.encode!()

    assigns =
      %{}
      |> Map.put(:type, type)
      |> Map.put(:event, event)
      |> Map.put(:dimensions, dimensions)

    ~H"""
    <script>
      gtag("<%= @type %>", "<%= @event %>", <%= Phoenix.HTML.raw(@dimensions) %>)
    </script>
    """
  end
end
