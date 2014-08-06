defmodule XML do
  import Record

  defrecord :xmlElement,
            Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  defrecord :xmlAttribute,
            Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  defrecord :xmlText,
            Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  def doc(str) do
    :xmerl_scan.string to_char_list(str)
  end

  def xpath(document, path) do
    :xmlerl_xpath.string to_char_list(path), document
  end
end
