function Str(el)
  local text = el.text
  if not text:find("!!", 1, true) then
    return nil
  end
  local result = {}
  local rest = text
  while true do
    local before, keyword, after = rest:match("^(.-)!!(.-)!!(.*)$")
    if keyword then
      if before ~= "" then
        table.insert(result, pandoc.Str(before))
      end
      table.insert(result, pandoc.Span({ pandoc.Str(keyword) }, pandoc.Attr("", {"quiz"}, {})))
      rest = after
    else
      if rest ~= "" then
        table.insert(result, pandoc.Str(rest))
      end
      break
    end
  end
  return result
end