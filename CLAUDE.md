# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 이 저장소의 성격

개인 학술 포트폴리오 사이트를 **Quarto**로 만든 것입니다. 옆 디렉터리 `../djchoi/`(Hugo + bloggraph 테마)와 **같은 내용을 의도적으로 중복**해서 두 도구를 비교하기 위한 시험판입니다.

- `../djchoi/`는 **건드리지 마세요.** 별도의 git 저장소이고 이 프로젝트와 독립적으로 유지됩니다.
- 이 디렉터리는 아직 **git 저장소가 아닙니다** (`.gitignore`만 있고 `.git`은 없음).
- 두 사이트의 내용이 어긋나는 것은 버그가 아닙니다 — 비교가 목적입니다.

## 명령어

Quarto는 winget으로 설치되어 `C:\Program Files\Quarto\bin`에 있습니다.

```
quarto preview          # 라이브 리로드 개발 서버 (파일 저장 시 자동 재빌드)
quarto render           # 전체 빌드 → _site/
quarto render index.qmd # 파일 하나만 빌드 (빠른 확인용)
quarto check            # 설치 상태 진단
quarto publish gh-pages # GitHub Pages 배포
```

### Windows 환경 주의사항

- **설치 직후 열려 있던 터미널에서는 `quarto`를 찾지 못합니다.** PATH가 갱신되지 않기 때문이며, 새 터미널을 열면 해결됩니다.
- `& "C:\Program Files\Quarto\bin\quarto.cmd"`처럼 **전체 경로로 직접 호출하면 실패합니다.** 배치 래퍼가 자기 경로의 공백을 처리하지 못해 번들된 deno를 못 찾습니다. PATH를 통해 `quarto`로 호출하거나, 굳이 절대경로가 필요하면 8.3 단축 경로 `C:\PROGRA~1\Quarto\bin\quarto.cmd`를 쓰세요.

## 구조

### 설정 상속

`_quarto.yml`의 최상위 키(`csl`, `date-format`, `lang`)는 **모든 `.qmd` 문서의 front matter로 병합**됩니다. 한 페이지에서만 나타나는 문제도 원인이 `_quarto.yml`에 있을 수 있으니 두 곳을 함께 보세요.

병합 방식이 키마다 다릅니다. 스칼라(`lang`, `csl`)는 문서 쪽이 **덮어쓰지만**, 리스트를 받는 `bibliography`는 **양쪽이 합쳐집니다.** 그래서 `bibliography`는 전역에서 뺐습니다 (아래 "인용·서지" 참고).

### Home 페이지 (`index.qmd`)

제목은 `Dong-june Choi's Personal Webpage`이고, 목차가 필요 없어 `toc: false`입니다.

레이아웃은 **Quarto/Bootstrap 의 12칸 CSS 그리드**입니다. `::: {.grid}` 안에 블록 두 개를 두고,
각 블록에 클래스를 두 벌 겁니다.

| 클래스 | 언제 적용되나 |
|---|---|
| `.g-col-12` | 항상. 모바일에서는 이 값만 살아 12칸(=전체 너비)이 되어 위아래로 쌓입니다 |
| `.g-col-md-5` / `.g-col-md-7` | 768px 이상에서만. 사진 5칸 + 소개 글 7칸의 두 단이 됩니다 |

좌우 비율을 바꾸려면 `md` 숫자 두 개를 고치되 **합이 12**가 되게 하세요.
쌓이는 순서는 문서에 적힌 순서 그대로입니다 (사진 → 연락처 → 소개 글).

**사진 크기는 파일이 아니라 칼럼 폭이 정합니다.** `styles.css`의 `.profile-photo`가
`width: 100%`라서 들어 있는 칸을 채웁니다. `.qmd`에 `{width=...}`를 적지 마세요 — 그러면
모바일에서 화면 너비에 맞추지 못합니다.

`![](my-photo.jpg){.profile-photo fig-alt="..."}` 처럼 **대괄호 안을 비워 두는 것**도
의도한 것입니다. 대괄호에 글을 넣으면 Pandoc 이 그걸 캡션으로 보고 사진 아래에
`<figcaption>`을 만듭니다. 대체 텍스트는 `fig-alt`로 줍니다.

원본 사진 `My photo.jpg`는 5712×4284, 3.6 MB에 **EXIF orientation 6**("표시할 때
시계방향 90도 회전")이 걸린 세로 사진입니다. 웹용 `my-photo.jpg`(900×1200, 168 KB)는
원본을 실제로 90도 돌려서 구운 것이라 EXIF 태그가 없어도 바로 서서 보입니다.

사진을 바꿀 때 주의할 점이 둘 있습니다.

1. **EXIF orientation 을 먼저 확인하세요.** 휴대폰 사진은 픽셀은 가로로 저장하고
   "돌려서 보라"는 태그만 붙는 일이 흔합니다. 이 태그를 지우면서 리사이즈하면
   브라우저에서 사진이 눕습니다. 픽셀 자체를 돌려서 저장하는 게 안전합니다.
2. **긴 변을 1200px 정도로 줄이세요.** 세로 사진이면 900×1200 근처가 됩니다.

### Research/Publication 페이지 (`publications.qmd`)

네비게이션 이름은 `Research/Publication`이고 **파일 이름은 `publications.qmd`**입니다
(주소 `/publications.html`).

`publications.qmd`는 뼈대(front matter + 섹션 제목 + include)만 들고 있습니다.
내용은 전부 바깥 파일에 있습니다.

| 섹션 | 내용이 있는 곳 | 어떻게 들어가나 |
|---|---|---|
| Research Interests | `_research-interests.qmd` | `{{< include >}}` |
| In Preparation | `_in-preparation.qmd` | `{{< include >}}` (제목만 나열, 링크 없음) |
| Publications | `publications.bib` | `nocite: @*` → `::: {#refs}` |

`_` 로 시작하는 파일은 **별도 페이지로 렌더되지 않습니다.** include 대상 파일에는
front matter를 넣지 마세요. 페이지에서 `##` 아래에 들어가므로 안쪽 제목은 `###`부터입니다.

**listing을 쓰지 않습니다.** 예전에는 `publications/*.qmd` 폴더를 listing으로 카드화했지만,
서지 목록이 그 역할을 하므로 걷어냈고 관련 파일(`publications/`, `in-preparation/`,
`_templates/`, `_archive/`)은 전부 삭제했습니다. 되살릴 일이 있으면 listing 함정
(아래 "알려진 함정")을 먼저 읽으세요.

Publications 섹션의 **출력 순서는 `publications.bib`에 적힌 순서**를 그대로 따릅니다.
IEEE CSL은 인용 번호 순이라 별도 정렬을 하지 않습니다. 최신 논문이 위에 오게 파일을 정렬하세요.

### 서지 항목의 `[journal]` `[arXiv]` 링크 — `pub-links.lua`

`publications.bib` 의 `note` 필드에 마크다운 링크를 적으면 서지 항목 끝에 붙습니다.
안 적으면 아무것도 안 붙습니다.

```bibtex
note = {[journal](https://doi.org/10.xxxx/yyy) [arXiv](https://arxiv.org/abs/2601.00001)}
```

이렇게 우회한 이유가 셋 있습니다. 다른 방법을 시도하기 전에 읽으세요.

1. **IEEE CSL은 `note`를 출력하지 않습니다.** 그래서 CSL 출력에 직접 덧붙여야 합니다.
2. **`url`/`doi`/`eprint`는 슬롯이 하나뿐**이라 서로 덮어씁니다. 둘을 동시에 못 보여줍니다.
   `doi`를 넣으면 IEEE가 "doi: ..."를 따로 찍어 `[journal]`과 중복되니 넣지 마세요.
3. **BibTeX 사용자 정의 필드는 Pandoc이 버립니다.** `journalurl` 같은 걸 넣어도
   `pandoc.utils.references()`까지 살아남지 않습니다. 살아남는 자유 필드가 `note`뿐입니다.

**`publications.qmd`의 `citeproc: false`를 지우지 마세요.** Quarto는 citeproc를
모든 필터 진입 지점(`pre-quarto` ~ `post-finalize`)보다 **뒤에** 돌립니다. 확인해 봤고,
어느 지점에 필터를 걸어도 그 시점의 `#refs`는 비어 있습니다. 그래서 Quarto 쪽 citeproc를
끄고 `pub-links.lua`가 `pandoc.utils.citeproc()`를 직접 부릅니다.
`filters: [citeproc, ...]` 처럼 목록에 `citeproc`를 적는 방법은 **동작하지 않습니다** —
Quarto가 그걸 파일 경로로 보고 찾다가 실패합니다.

링크를 `csl-right-inline` **안쪽**에 넣는 것도 중요합니다. IEEE는 항목을
"[1]"(`csl-left-margin`)과 본문(`csl-right-inline`) 두 칸으로 쪼개는데, 바깥에 붙이면
다음 줄 맨 왼쪽으로 떨어집니다. 대괄호는 `styles.css`의 `.pub-links`가 씌웁니다.

`publications.qmd` 본문에는 이제 손댈 것이 없습니다. 세 섹션이 모두 바깥 파일에서
채워지므로, 논문을 넣고 뺄 때도 이 파일은 열지 않습니다.

### 인용·서지 — `.bib` 두 개

| 파일 | 용도 |
|---|---|
| `publications.bib` | **내 논문.** Publications 섹션이 이 파일 전체를 출력 |
| `references.bib` | 본문에서 `[@key]`로 인용하는 **남의 논문** |

**`_quarto.yml`에 `bibliography:`를 두면 안 됩니다.** 전역 `bibliography`는 페이지
front matter와 *덮어쓰기가 아니라 배열로 병합*되어 `[references.bib, publications.bib]`가
되고, 그러면 `nocite: @*`가 남의 논문까지 내 업적 목록에 찍습니다. 실제로 한 번 밟은 함정입니다.
전역에는 `csl:`(IEEE, Zotero 원격 URL)만 남겨 두었고, `bibliography:`는 페이지마다 지정합니다.

인용을 쓰는 페이지를 새로 만들면 front matter에 `bibliography: references.bib`를 적으세요.

**`publications.qmd`와 거기 include되는 두 파일에서는 `[@key]` 인용을 쓸 수 없습니다** —
그 페이지의 서지가 `publications.bib`만 보고 있어서 인용이 풀리지 않습니다.
소개 글에서 남의 논문을 언급해야 하면 마크다운 링크를 쓰세요.

### 에셋 경로

이미지·PDF는 참조하는 `.qmd` 파일 기준 상대경로입니다. 지금 사이트가 쓰는 에셋은 `cv/`의 PDF와 `my-photo.jpg`(index.qmd)입니다.

**참조하는 문서가 없는 에셋은 `_site`로 복사되지 않습니다.** 배포에 넣으려면 `_quarto.yml`의 `project: resources:`에 적어야 합니다. 지금 거기 등록된 것은 둘입니다.

| 항목 | 이유 |
|---|---|
| `cv/` | `<object>` 로만 참조되는 PDF라 폴더째 복사합니다 |
| `"google*.html"` | Google Search Console 소유권 확인 파일. 어느 문서도 참조하지 않습니다 |

와일드카드가 아무것도 못 잡아도 빌드는 정상입니다. 확인 파일을 프로젝트 루트에 두기만 하면 배포에 실려 갑니다.

원본 사진 `My photo.jpg`는 어느 문서도 참조하지 않으므로 빌드 결과에 들어가지 않고, **EXIF에 GPS 좌표(촬영 위치)가 있어 `.gitignore`로도 막아 두었습니다.** 저장소가 공개이기 때문입니다. 웹용 `my-photo.jpg`는 EXIF가 제거된 상태라 커밋해도 됩니다.

### CV 페이지

`cv.qmd`가 `cv/` 폴더의 PDF를 페이지 안에 띄우고(`<object>`), 다운로드·새 탭 버튼을 겁니다. 페이지 문구는 영문(`lang: en`)입니다.

**파일 이름은 `cv.qmd` front matter의 `cv-file` 한 곳에만 있습니다.** 본문은 전부
`{{< meta cv-file >}}` 로 그 값을 끌어다 씁니다. CV를 갱신할 때는 새 PDF를 `cv/`에 넣고
`cv-file`, `cv-updated` 두 줄만 고치면 됩니다. 본문에 파일 이름을 다시 적지 마세요.

- `cv-download-name`은 저장될 때의 파일 이름(`<a download>`)입니다. 날짜가 없으므로
  갱신할 때 손댈 필요가 없습니다.
- `_quarto.yml`의 `project: resources: - cv/`가 폴더를 통째로 `_site`에 복사합니다.
  이 줄이 없으면 raw HTML(`<object>`)로만 참조된 PDF가 빌드 결과에 빠질 수 있습니다.
  예전 CV 파일을 `cv/`에 남겨 두어도 링크가 끊기지 않습니다.
- `<object>`를 쓴 이유는 PDF를 못 띄우는 브라우저(주로 모바일)에서 안내 문구로
  대체되기 때문입니다. `<iframe>`으로 바꾸면 그런 환경에서 빈 칸이 됩니다.

## 알려진 함정

### `lang: ko` + listing = 카드 깨짐

지금 이 사이트는 **listing을 쓰지 않습니다** (논문 목록을 `.bib` 서지로 대체). 아래는 listing을 다시 도입할 때를 위한 기록입니다.

`lang: ko`를 켜면 날짜 기본 형식이 `date-format: long`(한국어)으로 바뀌는데, 이 상태에서 **listing 카드 템플릿의 fenced div 파싱이 깨집니다.** 증상은 카드 안에 `:::` 문자가 그대로 출력되고 날짜가 "2025-01-27" 대신 "27."로 잘리는 것입니다. 빌드는 성공하고 `Div at line N unclosed` 경고만 나오므로 놓치기 쉽습니다.

`_quarto.yml`의 `date-format: "YYYY-MM-DD"`가 이 문제를 막고 있습니다. **이 줄을 지우지 마세요.**

listing이나 `lang` 설정을 건드린 뒤에는 렌더된 HTML에 `:::`가 남아 있는지 반드시 확인하세요:

```
quarto render publications.qmd
```

빌드 로그에 `Div at line ... unclosed` 또는 `The following string was found in the document: :::`가 있으면 실패한 것입니다.

### `.qmd`·`.bib` 에서 LaTeX 습관이 만드는 사고

수학 원고를 쓰던 습관으로 파일을 고치면 조용히 깨지는 지점이 넷 있습니다.
전부 실제로 한 번씩 밟았습니다.

**1. `.qmd` 에서 `%` 는 주석이 아닙니다.** 그대로 화면에 찍힙니다.
마크다운 주석은 HTML 주석뿐입니다.

**2. HTML 주석 안에 닫는 기호를 글자 그대로 적으면 거기서 주석이 끝납니다.**
뒤에 남은 설명이 본문으로 새어 나옵니다. 주석 안에서 주석 문법을 설명하지 마세요.

**3. `.qmd` 본문에서 `\"{o}` 같은 LaTeX 명령은 통하지 않습니다.**
`Szeg\"{o}` 는 `Szeg"{o}` 로 찍힙니다. `ö` 처럼 글자를 직접 쓰세요.
`$...$` 수식 **안에서는** LaTeX 문법이 정상 동작합니다.

**4. `.bib` 항목 *안*에서도 `%` 는 주석이 아닙니다.** 항목 바깥에서만 주석입니다.
필드를 잠시 빼려면 `%` 를 붙이지 말고 그 줄을 지우세요.

### IEEE CSL 은 논문 제목을 소문자로 눕힙니다

sentence case 라 고유명사도 같이 눕습니다.
`the Szegö projection on the Hartogs triangle` → `the szegö projection on the hartogs triangle`.

`.bib` 의 `title` 에서 지킬 단어를 **중괄호로 감싸야** 합니다.

```bibtex
title = {Sharp $L^p$ regularity of the {Szegö} projection on the {Hartogs} triangle}
```

수식(`$L^p$`)은 감싸지 않아도 그대로 보존됩니다.

### `quarto preview` 를 켠 채로 `quarto render` · `quarto publish` 를 돌리지 마세요

둘 다 `_site/` 에 결과를 쓰기 때문에 서로 덮어씁니다. 증상이 헷갈립니다.

- 고친 내용이 반영되지 않고 **옛 페이지가 계속 나옵니다** (preview 가 자기 렌더로 덮어씀).
- 심하면 `render` 가 파일 이동 중에 실패합니다:
  `NotFound ... rename '...html' -> '_site/...html'`.
- 그 상태에서 `_site` 를 지우면 **참조된 에셋이 같이 사라집니다.**
  (실제로 `receipt.pdf` 를 한 번 잃었습니다.)

**`quarto publish gh-pages` 도 내부에서 render 를 돌리므로 똑같이 깨집니다.**
그런데 이쪽은 증상이 훨씬 고약합니다 — **명령이 에러 없이 끝난 것처럼 보이는데
`gh-pages` 브랜치에 파일이 하나도 안 올라갑니다.** 브랜치는 만들어지고
`Initializing gh-pages branch` 커밋까지 찍히기 때문에 성공한 줄 알기 쉽습니다.

이 상태에서 `<user>.github.io` 저장소라면 GitHub 이 `main` 을 Jekyll 로 렌더해서
**README 가 홈페이지로 뜹니다.** 사이트는 멀쩡히 200 을 주는데 내용이 딴것입니다.

의심되면 브랜치 내용을 세어 보세요. 0 이면 실패한 것입니다.

```
git ls-tree -r origin/gh-pages --name-only | wc -l
```

프로젝트 **루트**에 `publications.html` 이나 `site_libs/` 가 떨어져 있는 것도
같은 사고의 흔적입니다. `_site/` 로 옮겨지지 못하고 중간에 멈춘 산출물이니 지우세요.

빌드를 검증할 때는 preview 를 먼저 끄세요. 반대로 preview 로 확인 중이라면
`quarto render` 를 따로 돌리지 말고 preview 가 갱신한 화면을 보면 됩니다.

### Pandoc 마크다운 문법 차이

Hugo에서 옮겨온 내용을 수정할 때 걸리는 지점들입니다.

| | Hugo (bloggraph) | Quarto (Pandoc) |
|---|---|---|
| 블록 수식 | `\[ ... \]` | `$$ ... $$` |
| 인라인 수식 | `\( ... \)` | `$ ... $` |
| 중첩 인용문 | `>` 다음 줄에 바로 `>>` | 단계 사이에 `>`만 있는 빈 줄 필요 |

수식은 **별도 설정 없이 MathJax로 렌더링**됩니다. KaTeX/MathJax 스크립트를 추가하지 마세요. `_quarto.yml`의 `html-math-method: katex` 주석을 해제하면 KaTeX로 바뀝니다.

### `feed: true`는 `site-url`을 요구함

listing에 RSS를 켜려면 `_quarto.yml`에 `site-url`이 있어야 합니다. 없으면 `Unable to create a feed` 경고와 함께 무시됩니다. 배포 주소가 정해진 뒤에 켜세요.

### 검색 결과 제목은 `pagetitle` 로 못 바꿉니다 — 사이트 제목을 고치세요

구글이 검색 결과 제목으로 쓰는 것은 `<title>` 태그인데, Quarto 웹사이트는 이 값을
항상 **`문서 제목 – 사이트 제목`** 으로 조립합니다.

front matter 의 `pagetitle` 로 덮어쓰는 방법은 **동작하지 않습니다.** 시도해 봤고
웹사이트 모드에서는 무시됩니다. (같은 front matter 의 `description-meta` 는 정상
적용되므로, front matter 를 안 읽는 것이 아니라 `pagetitle` 만 덮어써집니다.)

대신 사이트 제목을 원하는 문구로 두고, navbar 에 보이는 짧은 이름을 따로 지정하세요.

```yaml
website:
  title: "Dong-june Choi's Personal Webpage"   # <title> 에 들어가는 값
  navbar:
    title: "Dong-june Choi"                    # 화면 왼쪽 위에 보이는 이름
```

홈은 문서 제목과 사이트 제목이 같아서 Quarto 가 중복을 지우고 한 번만 찍습니다.
나머지 페이지는 `CV – Dong-june Choi's Personal Webpage` 처럼 됩니다.

`website: title:` 을 짧은 이름으로 되돌리면 검색 결과 제목도 같이 짧아집니다.

### `site-url` 을 바꾸면 `_site/sitemap.xml` 을 지우세요

**Quarto 는 sitemap 을 새로 만들지 않고 기존 파일에 병합합니다.** 그래서 `site-url` 을
바꾸면 옛 주소가 지워지지 않고 새 주소가 그 옆에 추가됩니다.

```xml
<loc>https://dj603.github.io/djchoi-quarto/index.html</loc>   <!-- 옛 주소. 404 가 됨 -->
<loc>https://dj603.github.io/index.html</loc>                 <!-- 새 주소 -->
```

이대로 Google Search Console 에 제출하면 없는 주소를 넘기게 됩니다.
`site-url` 을 고친 뒤에는 sitemap 을 지우고 전체 렌더를 한 번 돌리세요.

```
rm _site/sitemap.xml && quarto render
```

`quarto preview` 로는 확인할 수 없습니다. `--render` 기본값이 `none` 이라 방문한
페이지만 렌더하고 **sitemap 은 아예 만들지 않기 때문**입니다. 미리보기 화면에서
멀쩡해 보여도 이 문제는 그대로 남아 있습니다.

### 미리보기의 "Render" 흰 상자는 사이트 문제가 아님

`quarto preview` 중 처음으로 다른 페이지로 이동할 때 **"Render" 제목의 흰 상자**가 뜹니다.
`quarto preview`가 브라우저에 주입하는 `quarto-preview.js`의 진행 표시창이며,
렌더가 2초를 넘길 것 같으면 렌더 로그를 띄웁니다(에러 시 제목이 "Error"로 바뀜).
`--render` 기본값이 `none`이라 **페이지에 처음 들어갈 때 그 페이지를 렌더**하기 때문에
첫 이동에서만 보입니다.

빌드 결과물에는 이 스크립트가 들어가지 않으므로 **배포된 사이트에는 나타나지 않습니다.**

```
grep -c quarto-preview _site/*.html   # 전부 0
```

미리보기에서도 안 보이게 하려면 시작할 때 전부 렌더하세요.

```
quarto preview --render all
```

이 상자를 CSS나 JS로 숨기려 하지 마세요. 렌더 실패 메시지가 표시되는 창이 같은 것이라,
숨기면 빌드 에러를 놓치게 됩니다.

## 문서 언어

**화면에 보이는 문구는 전부 영어입니다.** 영문으로 배포하기로 해서 `_quarto.yml`의 전역 설정이 `lang: en`, `toc-title: "Contents"`로 바뀌었습니다. 새로 쓰는 본문·제목·버튼 문구도 영어로 쓰세요.

**유지보수용 주석과 문서(`CLAUDE.md`, `README.md`, `.qmd`/`.css`/`.yml` 안의 주석)는 한국어 그대로 둡니다.** 새로 다는 주석도 한국어로 맞춰주세요.

`cv.qmd` 에만 `lang: en` 이 남아 있습니다. 전역 설정과 같아서 없어도 되지만,
그 페이지가 영문이라는 표시로 남겨 두었습니다. `publications.qmd` 의 중복된
`lang` · `toc-title` 은 지웠습니다 — 전역 설정만으로 같은 결과가 나옵니다.

`styles.css`의 `:lang(ko) { word-break: keep-all }`는 지금은 적용되지 않습니다. 한국어 페이지를 다시 넣을 때(그 페이지 front matter에 `lang: ko`)를 대비해 남겨 둔 규칙입니다.
