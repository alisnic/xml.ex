defmodule XML do
  def parse(str) do
    :mochiweb_html.parse(str)
  end

  def xpath(document, path_str) do
    :mochiweb_xpath.execute path_str, document
  end

  def path([], _), do: []
  def path(documents, []), do: documents
  def path(doc = {_, _, _,}, path_str), do: path([doc], path_str)

  def path(documents, [part]) do
    Enum.filter documents, &is(&1, part)
  end

  def path(documents, [part|rest]) do
    documents
    |> Enum.filter(&is(&1, part))
    |> Enum.map(&path(children(&1), rest))
    |> Enum.filter(fn(x)-> length(x) > 0 end)
    |> Enum.reduce([], fn(e, acc)-> acc ++ e end)
  end

  def path(documents, path_str) do
    parts = String.split(path_str, "/") |> Enum.filter(fn s -> String.length(s) > 0 end)
    path documents, parts
  end

  def is([h|_t], name), do: is(h, name)
  def is({name, _attrbutes, _children}, value), do: name == to_string(value)

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
    |> Enum.find({nil, nil}, fn attr -> elem(attr, 0) == to_string(name) end)
    |> elem(1)
  end
end
