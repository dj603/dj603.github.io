# Quarto 시험판 — Hugo 사이트와 비교용

`djchoi/` (Hugo + bloggraph)와 **같은 내용**을 Quarto로 만든 것입니다.
Hugo 저장소는 전혀 건드리지 않았습니다.

## 실행

Quarto 설치 후:

```
quarto preview
```

브라우저가 열리고, 파일을 저장할 때마다 자동으로 갱신됩니다 (`hugo serve`와 동일).

한 번만 빌드하려면 `quarto render` — 결과물은 `_site/`에 생깁니다.

> **`quarto preview`를 켠 채로 `quarto render`를 돌리지 마세요.** 둘 다 `_site/`에
> 쓰기 때문에 서로 덮어씁니다. 고친 내용이 반영되지 않고 옛 페이지가 계속 나오거나,
> `render`가 파일 이동 중에 실패합니다. 빌드를 확인할 때는 preview를 먼저 끄세요.

## 파일 구조와 Hugo 대응

| Quarto | Hugo |
|---|---|
| `_quarto.yml` | `config.toml` |
| `index.qmd` | `content/_index.md` |
| `cv.qmd` + `cv/*.pdf` | `content/cv/_index.md` + `static/` |
| `publications.qmd` | `content/publications/_index.md` |
| `_research-interests.qmd` | (소개 글 조각 — include 전용, 렌더 안 됨) |
| `_in-preparation.qmd` | (진행 중인 연구 제목 목록 — include 전용) |
| `teaching.qmd` | `content/teaching/_index.md` |
| `publications.bib` | (대응 없음 — 내 논문 목록) |
| `references.bib` | (대응 없음 — 인용하는 남의 논문) |
| `pub-links.lua` | (대응 없음 — 서지에 [journal]/[arXiv] 링크를 붙이는 필터) |
| `styles.css` | 테마 SCSS |
| `_site/` | `public/` |

## Hugo에서 옮길 때 바뀌는 문법

| | Hugo (bloggraph) | Quarto |
|---|---|---|
| 블록 수식 | `\[ ... \]` | `$$ ... $$` |
| 인라인 수식 | `\( ... \)` | `$ ... $` |
| 논문 목록 | `{{< publication/list >}}` shortcode | `publications.bib` + `nocite: @*` |
| 이미지 크기 | 테마 shortcode | `![](a.jpg){width="70%"}` — 단, 프로필 사진에는 쓰지 마세요(아래 "홈 화면 관리") |
| 중첩 인용문 | `>` 다음 줄에 바로 `>>` | 단계 사이에 `>`만 있는 빈 줄 필요 |

나머지(제목, 리스트, 코드 블록, 링크, 각주)는 **문법이 동일**합니다.

## 실제로 겪은 함정 세 가지

### 1. `lang: ko` + listing = 카드가 깨짐

> 지금 이 사이트는 listing을 쓰지 않고(논문 목록을 `.bib` 서지로 바꿨음),
> 영문으로 배포하기 위해 `lang: en`으로 바꿨습니다. 그래서 이 함정은 지금은 발생하지 않습니다.
> 아래는 한국어 페이지나 listing을 다시 도입할 때를 위해 남겨 둔 기록입니다.
> (`date-format` 줄은 그대로 두세요.)

`_quarto.yml`에 `lang: ko`를 넣으면 날짜 기본 형식(`date-format: long`)이 한국어로 바뀌는데,
이때 **listing 카드 템플릿이 깨져서 카드 안에 `:::` 문자가 그대로 출력**됩니다.
날짜도 "2025-01-27"이 아니라 "27."로 잘립니다.

해결: `_quarto.yml`에 날짜 형식을 명시합니다.

```yaml
lang: ko
date-format: "YYYY-MM-DD"
```

### 2. 설치 직후 `quarto` 명령을 못 찾음

winget으로 설치한 뒤 **기존에 열려 있던 터미널에서는 PATH가 갱신되지 않습니다.**
터미널을 새로 열면 정상 동작합니다.

### 3. 첫 페이지 이동 때 "Render" 흰 상자가 뜸

`quarto preview`로 띄운 뒤 처음으로 다른 페이지(Publications, Teaching 등)로 넘어가면
**"Render"라는 제목의 흰 상자**가 잠깐 떴다 사라집니다.

이건 사이트 버그가 아니라 **미리보기 서버의 진행 표시창**입니다.
`quarto preview`는 브라우저에 `quarto-preview.js`를 끼워 넣는데, 이 스크립트가
렌더가 2초를 넘길 것 같으면 로그를 보여주는 창을 띄웁니다
(에러가 나면 같은 자리에 제목이 "Error"로 바뀝니다).

`quarto preview`의 `--render` 기본값이 `none`이라 시작할 때 아무것도 렌더하지 않고,
**페이지에 처음 들어가는 순간 그 페이지를 렌더**하기 때문에 첫 이동에서만 보입니다.

- **배포된 사이트에는 이 상자가 없습니다.** `quarto render`가 만든 `_site/*.html`에는
  `quarto-preview.js`가 들어가지 않습니다 (`grep quarto-preview _site/*.html` → 0건).
- 미리보기에서도 안 보이게 하려면 시작할 때 전부 렌더해 두면 됩니다:

```
quarto preview --render all
```

시작이 몇 초 느려지는 대신, 이후 페이지 이동은 이미 만들어 둔 HTML을 그대로 내보내므로
상자가 뜨지 않습니다.

## 홈 화면 관리 (`index.qmd`)

한 파일만 고치면 됩니다. 구조는 이렇습니다.

```
::: {.grid}
  ::: {.g-col-12 .g-col-md-5}   ← 왼쪽 단: 사진 + 연락처
  ::: {.g-col-12 .g-col-md-7}   ← 오른쪽 단: 소개 글
:::
```

- **데스크톱(768px 이상)**: `md` 클래스가 살아나 5:7 두 단이 됩니다.
- **모바일**: `g-col-12`만 남아 전체 너비로 위아래로 쌓입니다
  (사진 → 연락처 → 소개 글, 문서에 적힌 순서 그대로).

자주 하는 수정:

| 하고 싶은 것 | 고칠 곳 |
|---|---|
| 좌우 비율 바꾸기 | `index.qmd`의 `g-col-md-5` / `g-col-md-7` (합이 12) |
| 사진 바꾸기 | 긴 변 1200px 정도로 줄이고, EXIF 회전은 픽셀에 구워서 `my-photo.jpg`로 저장 |
| 사진 모서리·여백 | `styles.css`의 `.profile-photo` |
| 연락처·소개 글 | `index.qmd` 본문 |

사진 크기를 `.qmd`에서 `{width=...}`로 지정하지 마세요. 지금은 `.profile-photo`가
`width: 100%`라서 **들어 있는 단의 폭을 그대로 따라갑니다** — 그래서 데스크톱에서는
한 단 너비, 모바일에서는 화면 너비가 됩니다. 픽셀을 박으면 이 동작이 깨집니다.

원본 `My photo.jpg`(5712×4284, 3.6 MB)는 웹에 쓰기엔 너무 커서 `my-photo.jpg`
(900×1200, 168 KB)로 줄여 두었습니다. 원본은 참조되지 않으므로 배포에 포함되지 않습니다.

원본은 **EXIF orientation 6**("표시할 때 시계방향 90도 회전")이 붙은 세로 사진입니다.
리사이즈하면서 이 태그가 사라지면 브라우저에서 사진이 눕기 때문에, 웹용 파일은
픽셀 자체를 90도 돌려서 구웠습니다. 사진을 갈아 끼울 때도 같은 점을 확인하세요.

## 연구/논문 페이지 관리

`Research/Publication` 탭(`publications.qmd`)은 세 부분으로 나뉘고,
**각 부분을 고치는 파일이 서로 다릅니다.** `publications.qmd`는 뼈대만 들고 있어서
평소에 열 일이 없습니다. 사이트 전체가 영문(`lang: en`)이므로 본문은 영어로 씁니다.

| 화면에 보이는 것 | 고칠 곳 | 한 번에 하는 일 |
|---|---|---|
| Research Interests (소개 글) | `_research-interests.qmd` | 문단 고쳐 쓰기 |
| In Preparation (제목 나열) | `_in-preparation.qmd` | 목록에 줄 하나 추가/삭제 |
| Publications (서지 목록) | `publications.bib` | BibTeX 항목 하나 추가 (링크는 `note` 필드) |

### 소개 글 고치기

`_research-interests.qmd` 하나만 열면 됩니다. 이름 앞에 `_`가 붙어 있어
**이 파일은 별도 페이지로 만들어지지 않고** `publications.qmd`의
`{{< include >}}` 자리에 그대로 끼워집니다. 페이지 설정(front matter)을 건드릴 위험이 없습니다.

페이지에서 `## Research Interests` 아래에 들어가므로 파일 안 제목은 `###`부터 씁니다.

### 진행 중인 연구 추가·삭제

`_in-preparation.qmd`의 불릿 목록에 줄을 넣고 빼면 끝입니다.
제목만 보여 주고 링크는 걸지 않습니다.

```markdown
- Cohomology of some moduli space
- Spectral gap for random walks on X (with A. Coauthor)
```

제목만으로 부족하면 `— 한 줄 설명`이나 `(with 공저자)`를 붙여도 됩니다. 형식은 자유입니다.

### 논문 추가 (= 출판됐을 때)

`publications.bib`에 BibTeX 항목을 붙여넣으면 Publications 섹션에 자동으로 나옵니다.
진행 중이던 것이 나온 경우라면 `_in-preparation.qmd`에서 해당 줄만 지우면 됩니다.

**출력 순서는 `publications.bib`에 적힌 순서를 그대로 따릅니다.**
(IEEE 스타일은 인용 번호 순이라 CSL이 따로 정렬하지 않습니다.)
최신 논문을 맨 위에 두세요.

파일 아래쪽에 예시 두 개가 `%`로 주석 처리돼 있습니다. 형식 참고용이니
복사해서 쓰거나 지우세요.

**제목의 고유명사는 중괄호로 감싸세요.** IEEE는 논문 제목을 소문자로 눕히기 때문에
(sentence case) 감싸지 않으면 `the szegö projection on the hartogs triangle`이 됩니다.

```bibtex
title = {Sharp $L^p$ regularity of the {Szegö} projection on the {Hartogs} triangle}
```

수식(`$L^p$`)은 감싸지 않아도 그대로 보존됩니다. 그리고 **항목 *안*에서 `%`는
주석이 아닙니다** — 필드를 빼려면 `%`를 붙이지 말고 그 줄을 지우세요.

### 학술지·arXiv 링크 붙이기

`note` 필드에 **마크다운 링크**를 적으면 서지 항목 끝에 `[journal]` `[arXiv]`처럼 붙습니다.

```bibtex
@article{choi2026spectral,
  title   = {Spectral Gap for Random Walks},
  author  = {Choi, Dong-june},
  journal = {Journal of Things},
  year    = {2026},
  note    = {[journal](https://doi.org/10.xxxx/yyy) [arXiv](https://arxiv.org/abs/2601.00001)}
}
```

결과: `[1] D. Choi, "Spectral gap for random walks," Journal of Things, 2026. [journal] [arXiv]`

- **`note`를 안 적으면 아무것도 안 붙습니다.** 링크를 적은 논문에만 나타납니다.
- 대괄호 안 글자가 그대로 라벨이 됩니다 — `[code]`, `[slides]`, `[talk]` 등 자유롭게.
- 대괄호 자체는 CSS(`styles.css`의 `.pub-links`)가 씌웁니다. `.bib`에는 `[journal](url)`만 적으세요.
- **`doi = {...}`는 넣지 마세요.** IEEE가 "doi: 10.xxxx"를 따로 찍어서 `[journal]`과 중복됩니다.
- URL에 물결표(`~`)가 있으면 공백으로 바뀝니다. `%7E`로 적으세요.

왜 `note`냐면, 살아남는 자유 필드가 그것뿐이기 때문입니다. `journalurl` 같은
사용자 정의 필드를 넣어도 Pandoc이 버리고, `url`·`doi`·`eprint`는 슬롯이 하나뿐이라
서로 덮어씁니다. 그리고 IEEE CSL은 `note`를 화면에 출력하지 않기 때문에
운반용으로 쓰기 딱 좋습니다.

실제로 링크를 붙이는 것은 `pub-links.lua` 필터입니다. 자세한 내용은 그 파일 주석을 보세요.
`publications.qmd`의 **`citeproc: false`는 지우면 안 됩니다** — Quarto의 citeproc가
모든 필터보다 뒤에 돌기 때문에, 필터가 직접 citeproc를 부르도록 해 둔 것입니다.

### .bib 파일이 두 개인 이유

| 파일 | 용도 |
|---|---|
| `publications.bib` | **내 논문.** Publications 섹션이 이 파일 전체를 출력합니다 |
| `references.bib` | 본문에서 `[@key]`로 인용하는 **남의 논문** |

Publications 섹션은 `nocite: @*`("인용 여부와 무관하게 전부 출력")로 만들어집니다.
그래서 한 파일에 섞어 두면 남이 쓴 논문이 내 업적 목록에 딸려 나옵니다.

같은 이유로 **`_quarto.yml`에는 `bibliography:`를 두지 않았습니다.** 전역에 두면
페이지 front matter와 *배열로 병합*되어 (`[references.bib, publications.bib]`)
`@*`가 결국 양쪽을 다 끌어옵니다. 인용이 필요한 페이지는 front matter에
`bibliography: references.bib`를 직접 적으세요. `csl:`만 전역으로 남아 있습니다.

> `publications.qmd`(와 거기 include되는 두 파일)에서는 `[@key]` 인용을 쓰지 마세요.
> 그 페이지의 서지는 `publications.bib`만 보고 있어서 인용이 풀리지 않습니다.
> 소개 글에서 남의 논문을 언급해야 하면 그냥 마크다운 링크를 쓰세요.

## CV 갱신하는 법

1. 새 PDF를 `cv/` 폴더에 넣습니다. (예전 파일은 지우지 않아도 됩니다)
2. `cv.qmd` 맨 위 두 줄만 고칩니다.

```yaml
cv-file: "cv/Choi_CV_Aug2026.pdf"   # 새 파일 이름
cv-updated: "August 2026"           # 페이지에 "Last updated"로 그대로 찍힘
```

끝입니다. 본문에는 파일 이름이 한 번도 나오지 않고 `{{< meta cv-file >}}`로만
참조하므로, 보기 화면·다운로드 버튼·새 탭 링크가 한꺼번에 따라 바뀝니다.

다운로드했을 때 저장되는 이름은 `cv-download-name`(`Choi_Dong-june_CV.pdf`)이며
날짜가 들어 있지 않아 갱신할 때 건드릴 일이 없습니다.

## 배포

GitHub Pages로 보내려면:

```
quarto publish gh-pages
```

## 참고

- Quarto 문서: <https://quarto.org/docs/websites/>
- listing(카드형 목록): <https://quarto.org/docs/websites/website-listings.html>
  — 지금 이 사이트는 쓰지 않습니다. 논문 목록은 `.bib` 서지가 대신합니다.
- 인용/서지: <https://quarto.org/docs/authoring/citations.html>
