defmodule NavigationWeb.PageHTML do
  use NavigationWeb, :html

  embed_templates("page_html/*")
  embed_templates("about_html/*")
  embed_templates("projects_html/*")
end
