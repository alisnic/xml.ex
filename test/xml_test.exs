defmodule XmlTest do
  use ExUnit.Case, async: true

  def simple_xml do
    """
    <html>
      <head>
        <title>Awesome</title>
      </head>
      <body>
        <p class="awesome">xml</p>
      </body>
    </html>
    """
  end

  def unicode_xml do
    """
    <html>
      <head>
        <title>Awesome</title>
      </head>
      <body>
        <p>ștefan cel mare</p>
      </body>
    </html>
    """
  end

  test "parses a simple xml" do
    tag = XML.doc(simple_xml) |> elem(1)
    assert tag == :html
  end

  test "parses a unicode xml" do
    tag = XML.doc(unicode_xml) |> elem(1)
    assert tag == :html
  end

  test "finds element children" do
    [child] = simple_xml
    |> XML.doc
    |> XML.xpath("/html/head/title")
    |> XML.children

    assert elem(child, 0) == :xmlText
  end

  test "returns element content" do
    content = simple_xml
    |> XML.doc
    |> XML.xpath("/html/head/title")
    |> XML.content

    assert content == "Awesome"
  end

  test "finds all attributes" do
    attrs = simple_xml
    |> XML.doc
    |> XML.xpath("/html/body/p")
    |> XML.attributes

    assert attrs == [{:class, "awesome"}]
  end

  test "finds a attribute by name" do
    class = simple_xml
    |> XML.doc
    |> XML.xpath("/html/body/p")
    |> XML.attribute(:class)

    assert class == "awesome"
  end

  test "finds title via xpath" do
    data = simple_xml
    |> XML.doc
    |> XML.xpath("/html/head/title")

    [ title ] = data
    assert elem(title, 1) == :title
  end
end
