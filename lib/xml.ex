defmodule XML do
  def parse(str) do
    :mochiweb_html.parse(str)
  end

  def xpath(document, path) do
    :mochiweb_xpath.execute path, document
  end

  def children([h|_t]),  do: children(h)
  def children(element), do: elem(element, 2)

  def text([h|_t]), do: text(h)
  def text(element) do
    children(element) |> Enum.find(&is_binary(&1))
  end

  def attributes([h|_t]), do: attributes(h)
  def attributes(element) do
    element |> elem(1)
  end

  def attribute([h|_t], name),  do: attribute(h, name)
  def attribute(element, name), do: Dict.get(attributes(element), name)
end
