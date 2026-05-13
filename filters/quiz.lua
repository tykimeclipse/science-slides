local function push_inline(target, inline)
  if inline ~= nil then
    table.insert(target, inline)
  end
end

local function process_quiz_inlines(inlines)
  local result = {}
  local quiz_buffer = {}
  local in_quiz = false
  local changed = false

  local function push_to_current(inline)
    if in_quiz then
      push_inline(quiz_buffer, inline)
    else
      push_inline(result, inline)
    end
  end

  for _, inline in ipairs(inlines) do
    if inline.t == "Str" and inline.text:find("!!", 1, true) then
      changed = true
      local rest = inline.text

      while true do
        local before, after = rest:match("^(.-)!!(.*)$")
        if before == nil then
          if rest ~= "" then
            push_to_current(pandoc.Str(rest))
          end
          break
        end

        if before ~= "" then
          push_to_current(pandoc.Str(before))
        end

        if in_quiz then
          push_inline(result, pandoc.Span(quiz_buffer, pandoc.Attr("", { "quiz" }, {})))
          quiz_buffer = {}
          in_quiz = false
        else
          quiz_buffer = {}
          in_quiz = true
        end

        rest = after
      end
    else
      push_to_current(inline)
    end
  end

  if in_quiz then
    push_inline(result, pandoc.Str("!!"))
    for _, inline in ipairs(quiz_buffer) do
      push_inline(result, inline)
    end
  end

  if changed then
    return result
  end

  return nil
end

function Inlines(inlines)
  return process_quiz_inlines(inlines)
end
