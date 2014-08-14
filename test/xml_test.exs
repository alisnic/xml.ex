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

  setup context do
    if context[:pending] == true do
      :nope
    else
      :ok
    end
  end

  def unicode_html do
    {:ok, body} = File.read("test/fixtures/list.html")
    body
  end

  test "finds element via path" do
    elem = XML.parse(simple_xml) |> XML.path("/html/head/title")
    assert XML.is(elem, :title)
  end

  test "handles complex path" do
    path = "/html/body/div/div/section/div/section/div/div/div/table/tbody/tr"
    results = XML.parse(unicode_html) |> XML.path(path)
    assert true == results |> Enum.at(0) |> XML.is(:tr)
  end

  test "tells ether a tag matches a name" do
    assert XML.parse(simple_xml) |> XML.is(:html) == true
  end

  test "parses a simple xml" do
    assert XML.parse(simple_xml) |> elem(0) == "html"
  end

  test "parses a unicode xml" do
    assert XML.parse(unicode_xml) |> elem(0) == "html"
  end

  test "parses a unicode html" do
    assert XML.parse(unicode_html) |> elem(0) == "html"
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

  @tag pending: true
  test "finds title via xpath" do
    data = simple_xml
    |> XML.parse
    |> XML.xpath("/html/head/title")

    [ title ] = data
    assert elem(title, 1) == :title
  end
end
