--[[
  논문 서지 항목 뒤에 [journal] [arXiv] 같은 링크를 붙이는 필터입니다.

  링크는 publications.bib 의 `note` 필드에 **마크다운**으로 적습니다.

      note = {[journal](https://doi.org/10.xxxx/yyy) [arXiv](https://arxiv.org/abs/2601.00001)}

  note 가 없으면 아무것도 붙지 않습니다 — 링크를 적은 논문에만 나타납니다.
  라벨은 대괄호 안 글자 그대로 나오므로 [code], [slides] 처럼 자유롭게 쓸 수 있습니다.

  ── 왜 이런 방식인가 (건드리기 전에 읽어 주세요) ──────────────────
  1) IEEE CSL 은 note 를 아예 출력하지 않고, url/doi/eprint 는 슬롯이 하나뿐이라
     서로 덮어씁니다. 그래서 CSL 이 만든 서지에 링크를 직접 덧붙입니다.
  2) BibTeX 에 journalurl 같은 사용자 정의 필드를 넣어도 Pandoc 이 버립니다.
     끝까지 살아남는 자유 필드가 note 뿐이라 이걸 운반용으로 씁니다.
  3) 이 필터는 citeproc 를 **직접 호출**합니다. Quarto 는 citeproc 를 모든 필터
     진입 지점(pre-quarto ~ post-finalize)보다 뒤에 돌리기 때문에, 필터 위치를
     어떻게 잡아도 그 시점에는 서지가 비어 있습니다. 그래서 publications.qmd 에서
     `citeproc: false` 로 Quarto 쪽을 끄고 여기서 직접 부릅니다.
     ※ `citeproc: false` 를 지우면 링크가 사라집니다.
--]]

-- note 마크다운을 인라인 요소로 변환
local function md_inlines(text)
  local doc = pandoc.read(text, "markdown")
  local first = doc.blocks[1]
  if first and first.content then
    return first.content
  end
  return pandoc.Inlines({})
end

local append_inlines, append_to_blocks

-- IEEE 는 항목을 "[1]"(csl-left-margin)과 본문(csl-right-inline) 두 칸으로 쪼개고,
-- 이 둘을 Plain 블록 안에 Span 으로 나란히 놓습니다. 그냥 Plain 끝에 붙이면
-- 본문 칸 *바깥*으로 나가 다음 줄 맨 왼쪽에 떨어지므로, 마지막 요소가 본문 칸이면
-- 그 안으로 파고들어 붙입니다.
append_inlines = function(inlines, extra)
  local last = inlines[#inlines]
  if last and last.classes and last.classes:includes("csl-right-inline") then
    if last.t == "Span" then
      return append_inlines(last.content, extra)
    elseif last.t == "Div" then
      return append_to_blocks(last.content, extra)
    end
  end
  for _, il in ipairs(extra) do
    inlines:insert(il)
  end
  return true
end

-- 뒤에서부터 훑어 글이 들어 있는 마지막 블록을 찾습니다.
append_to_blocks = function(blocks, extra)
  for i = #blocks, 1, -1 do
    local b = blocks[i]
    if b.t == "Plain" or b.t == "Para" then
      return append_inlines(b.content, extra)
    elseif b.t == "Div" or b.t == "BlockQuote" then
      if append_to_blocks(b.content, extra) then
        return true
      end
    end
  end
  return false
end

function Pandoc(doc)
  -- 1) citeproc 가 note 를 지우기 전에 인용 키 -> note 원문을 모아 둡니다.
  local notes = {}
  for _, ref in ipairs(pandoc.utils.references(doc)) do
    if ref.note then
      local text = pandoc.utils.stringify(ref.note)
      if text ~= "" then
        notes[ref.id] = text
      end
    end
  end

  -- 2) 서지를 만듭니다.
  doc = pandoc.utils.citeproc(doc)

  -- 3) note 를 적어 둔 항목에만 링크를 붙입니다.
  return doc:walk({
    Div = function(div)
      local key = div.identifier:match("^ref%-(.+)$")
      if not key or not notes[key] then return nil end
      local links = pandoc.Span(md_inlines(notes[key]), pandoc.Attr("", { "pub-links" }))
      append_to_blocks(div.content, { pandoc.Space(), links })
      return div
    end,
  })
end
