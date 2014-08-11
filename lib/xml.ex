defmodule XML do
  def parse(str) do
    :mochiweb_html.parse(str)
  end

  def xpath(document, path) do
    :mochiweb_xpath.execute path, document
  end

  def children([h|_t]),  do: children(h)
  def children({_name, _attributes, children}), do: children

  def text([h|_t]), do: text(h)
  def text(element) do
    children(element) |> Enum.find(&is_binary(&1))
  end

  def attributes([h|_t]), do: attributes(h)
  def attributes({_name, attributes, _children}), do: attributes

  def attribute([h|_t], name),  do: attribute(h, name)
  def attribute(element, name) do
    attributes(element)
    |> Enum.find(fn attr -> {name, _} = attr end)
    |> elem(1)
  end
end
