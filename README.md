# Gamco

This library aims to provide a wrapper around Google Analytics v4.
It offers some useful helpers to send data to GA.

## Installation

Add `gamco` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gamco, "~> 0.1.0"}
  ]
end
```

## Configuration

Provide your `TAG_ID` in your configuration file:

```elixir
# config/config.exs

config :my_app, MyAppWeb.Gamco,
  tag_id: "G-XXXXXXXXX",
  active: false
```

And activate it in your `config/production.exs`

```elixir
# config/prod.exs

config :my_app, MyAppWeb.Gamco, active: true
```

You can set up multiple `tag_id` in different environments if you need
it. Just add the `tag_id` in the proper config file.

## Usage

Add a `MyAppWeb.Gamco` module as the following example:

```elixir
# lib/my_app_web/gamco.ex

defmodule MyAppWeb.Gamco do
  use Gamco, otp_app: :my_app
end
```

Then import your Gamco module inside your phoenix view or component
depending on what you are using. Example:

```elixir
# lib/my_app_web/views/layout_view.ex

defmodule MyAppWeb.LayoutView do
  import MyAppWeb.Gamco
  ...
end
```

Usually you'll want to add your Google Analytics script
immediately after your `<head>` tag in your html template.

```elixir
# lib/my_app_web/templates/layout/root.html.heex

<!DOCTYPE html>
<html lang="en">
  <head>
    <%= ga_javascript_tags() %>
    ...
  </head>
  ...
</html>
```

This will send the default `page_view` event every time the user
navigates to a different path in your application. You can pass
other dimensions if you want to collect extra data. Example:

```elixir
# lib/my_app_web/templates/layout/root.html.heex

<!DOCTYPE html>
<html lang="en">
  <head>
    <%= ga_javascript_tags(extra_data: "FooBar") %>
    ...
  </head>
  ...
</html>
```

## Custom events

Also, you can send custom messages to Google Analytics per page
or when needed by using the `ga_tag` helper as the following example:

```elixir
# lib/my_app_web/templates/product/show.html.heex

<%= ga_tag("event", "product_view", product_id: @product.id) %>
```

## Secure data

There are sensitive information that you might not want to send
it directly to Google Analytics to prevent some vulnerabilities.
You can achieve this by using the `ga_secure` helper which
generates a digest for the passed value:

```elixir
# lib/my_app_web/templates/product/show.html.heex

<%= ga_tag("event", "product_view",
  user: ga_secure(@conn.assigns.current_user.id),
  product_id: @product.id) %>
```

By default the generated value is a MD5 digest. You can configure
which secure module will be used in your config using `secure_module`
option as the following:

```elixir
# config/config.exs

config :my_app, MyAppWeb.Gamco,
  tag_id: "G-XXXXXXXXX",
  secure_module: MyAppWeb.Secure
```

Then create your own secure module:

```elixir
# lib/my_app_web/secure.ex

defmodule MyAppWeb.Secure do
  def call(value) do
    :crypto.hash(:sha , value)
    |> Base.encode16()
    |> String.downcase()
  end
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/gamco>.
