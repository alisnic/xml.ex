defmodule XML do
  import Record

  def doc(str) do
    {xml, _rest} = :xmerl_scan.string(to_unicode_char_list(str))
    xml
  end

  def xpath(document, path) do
    :xmerl_xpath.string to_char_list(path), document
  end

  def children([h|t]),   do: children(h)
  def children(element), do: elem(element, 8)

  def content([h|t]),  do: content(h)
  def content(element) do
    children(element)
    |> Enum.find(fn c -> elem(c,0) == :xmlText end)
    |> elem(4)
    |> to_string
  end

  def attributes([h|t]), do: attributes(h)
  def attributes(element) do
    element
    |> elem(7)
    |> Enum.map(fn e -> {elem(e,1), to_string(elem(e,8))} end)
  end

  def attribute([h|t], name),   do: attribute(h, name)
  def attribute(element, name), do: Dict.get(attributes(element), name)

  defp to_unicode_char_list(str) do
    str
    |> to_char_list
    |> :unicode.characters_to_binary
    |> :erlang.bitstring_to_list
  end
end
