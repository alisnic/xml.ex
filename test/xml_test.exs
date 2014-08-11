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

  def unicode_html do
    {:ok, body} = File.read("test/fixtures/list.html")
    body
  end

  test "parses a simple xml" do
    tag = XML.parse(simple_xml) |> elem(0)
    assert tag == "html"
  end

  test "parses a unicode xml" do
    tag = XML.parse(unicode_xml) |> elem(0)
    assert tag == "html"
  end

  test "parses a unicode html" do
    tag = XML.parse(unicode_html) |> elem(0)
    assert tag == "html"
  end

  test "finds element children" do
    [child|_rest] = simple_xml
    |> XML.parse
    |> XML.children

    assert elem(child, 0) == "head"
  end

  test "returns element content" do
    content = simple_xml
    |> XML.parse
    |> XML.children
    |> Enum.at(0)
    |> XML.children
    |> Enum.at(0)
    |> XML.text

    assert content == "Awesome"
  end

  test "finds all attributes" do
    attrs = simple_xml
    |> XML.parse
    |> XML.children
    |> Enum.at(1)
    |> XML.children
    |> Enum.at(0)
    |> XML.attributes

    assert attrs == [{"class", "awesome"}]
  end

  test "finds a attribute by name" do
    class = simple_xml
    |> XML.parse
    |> XML.children
    |> Enum.at(1)
    |> XML.children
    |> Enum.at(0)
    |> XML.attribute(:class)

    assert class == "awesome"
  end

  test "finds title via xpath" do
    data = simple_xml
    |> XML.parse
    |> XML.xpath("/html/head/title")

    [ title ] = data
    assert elem(title, 1) == :title
  end
end
