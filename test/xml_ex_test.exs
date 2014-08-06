defmodule XmlExTest do
  use ExUnit.Case

  def simple_xml do
    """
    <html>
      <head>
        <title>Title</title>
      </head>
      <body>
        <p>xml</p>
      </body>
    </html>
    """
  end

  def unicode_xml do
    """
    <html>
      <head>
        <title>Title</title>
      </head>
      <body>
        <p>ștefan cel mare</p>
      </body>
    </html>
    """
  end

  test "parses a simple xml" do
    tag = XML.doc(simple_xml)
    |> elem(0)
    |> elem(1)

    assert tag == :html
  end

  test "parses a unicode xml" do
    tag = XML.doc(unicode_xml)
    |> elem(0)
    |> elem(1)

    assert tag == :html
  end
end
