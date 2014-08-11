defmodule XML do
  def parse(str) do
    :mochiweb_html.parse(str)
  end

  def xpath(document, path) do
    :mochiweb_xpath.execute path, document
  end

  def children([h|_t]),  do: children(h)
  def children(element), do: elem(element, 8)

  def text([h|_t]), do: text(h)
  def text(element) do
    children(element)
    |> Enum.find(fn c -> elem(c,0) == :xmlText end)
    |> elem(4)
    |> to_string
  end

  def attributes([h|_t]), do: attributes(h)
  def attributes(element) do
    element
    |> elem(7)
    |> Enum.map(fn e -> {elem(e,1), to_string(elem(e,8))} end)
  end

  def attribute([h|_t], name),  do: attribute(h, name)
  def attribute(element, name), do: Dict.get(attributes(element), name)

  defp to_unicode_char_list(str) do
    str
    |> :erlang.binary_to_list
    |> :unicode.characters_to_binary
  end
end
