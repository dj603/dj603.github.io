# Dong-june Choi — 개인 홈페이지

Quarto로 만든 개인 학술 홈페이지입니다.

- **사이트**: <https://dj603.github.io/>
- **저장소**: `dj603/dj603.github.io`
  - `main` — 소스 (`.qmd`, `.bib`, 설정)
  - `gh-pages` — 배포된 결과물. `quarto publish`가 자동으로 채웁니다. 직접 건드리지 마세요.

## 실행

Quarto 설치 후:

```
quarto preview
```

브라우저가 열리고, 파일을 저장할 때마다 자동으로 갱신됩니다.

한 번만 빌드하려면 `quarto render` — 결과물은 `_site/`에 생깁니다.

> **`quarto preview`를 켠 채로 `quarto render`나 `quarto publish`를 돌리지 마세요.**
> 둘 다 `_site/`에 쓰기 때문에 서로 덮어씁니다. `publish`의 경우 **에러 없이 끝난 것처럼
> 보이는데 `gh-pages` 브랜치가 비어 있는** 상태가 되어 알아차리기 어렵습니다.
> 자세한 내용은 `CLAUDE.md`의 "알려진 함정"에 있습니다.

## 파일 구조

| 파일 | 역할 |
|---|---|
| `_quarto.yml` | 사이트 전체 설정 (제목, 네비게이션, 배포 주소, 인용 스타일) |
| `index.qmd` | Home |
| `cv.qmd` + `cv/*.pdf` | CV (PDF를 페이지 안에 띄움) |
| `publications.qmd` | Research/Publication — 뼈대만. 내용은 아래 세 파일에서 옴 |
| `_research-interests.qmd` | 소개 글 조각 (include 전용, 별도 페이지로 렌더되지 않음) |
| `_in-preparation.qmd` | 진행 중인 연구 제목 목록 (include 전용) |
| `publications.bib` | **내 논문 목록** — Publications 섹션이 이 파일 전체를 출력 |
| `teaching.qmd` | Teaching |
| `references.bib` | 본문에서 `[@key]`로 인용하는 **남의 논문** |
| `pub-links.lua` | 서지 항목에 `[journal]`/`[arXiv]` 링크를 붙이는 Pandoc 필터 |
| `styles.css` | 사용자 정의 스타일 |
| `_site/` | 빌드 결과물 (git에서 제외) |

`_`로 시작하는 `.qmd`는 별도 페이지가 되지 않고 다른 문서에 끼워집니다.

## Quarto(Pandoc) 문법 메모

LaTeX 원고를 쓰던 습관으로 고치면 조용히 깨지는 지점들입니다.

| | 이렇게 쓰세요 |
|---|---|
| 블록 수식 | `$$ ... $$` |
| 인라인 수식 | `$ ... $` |
| 중첩 인용문 | 단계 사이에 `>`만 있는 빈 줄이 필요합니다 |
| 이미지 크기 | `![](a.jpg){width="70%"}` — 단, 프로필 사진에는 쓰지 마세요 (아래 "홈 화면 관리") |
| 주석 | HTML 주석만 됩니다. **`%`는 주석이 아니라 화면에 그대로 찍힙니다** |
| 특수문자 | `ö`처럼 글자를 직접 쓰세요. LaTeX 명령은 통하지 않습니다 |

수식은 **별도 설정 없이 MathJax로 렌더링**됩니다. KaTeX/MathJax 스크립트를 추가하지 마세요.

`.bib` 파일에서는 **항목 안에서도 `%`가 주석이 아닙니다.** 항목 바깥에서만 주석입니다.
필드를 잠시 빼려면 `%`를 붙이지 말고 그 줄을 지우세요.

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
(900×1200, 168 KB)로 줄여 두었습니다.

**원본은 git에 올리지 않습니다.** EXIF에 GPS 좌표(촬영 위치)가 들어 있고 이 저장소는
공개이기 때문에 `.gitignore`로 막아 두었습니다. 웹용 `my-photo.jpg`는 EXIF가 제거된
상태라 커밋해도 됩니다.

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

제목만으로 부족하면 한 줄 설명이나 `(with 공저자)`를 붙여도 됩니다. 형식은 자유입니다.

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

수식(`$L^p$`)은 감싸지 않아도 그대로 보존됩니다.

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
페이지 front matter와 배열로 병합되어 (`[references.bib, publications.bib]`)
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

### 사이트를 고친 뒤 하는 일

```
1. preview 를 끈다            ← 켜 둔 채로 publish 하면 조용히 실패합니다
2. quarto publish gh-pages    ← 사이트 갱신 (gh-pages 브랜치)
3. git add -A && git commit && git push   ← 소스 갱신 (main 브랜치)
```

**2번과 3번은 별개입니다.** `publish`만 하면 사이트는 바뀌어도 소스가 GitHub에 남지 않고,
`push`만 하면 소스만 올라가고 사이트는 그대로입니다.

### 배포가 제대로 됐는지 확인

```
git ls-tree -r origin/gh-pages --name-only | wc -l     # 0 이면 실패
curl -sI https://dj603.github.io/ | head -1            # 200 이어야 함
```

GitHub 저장소 **Settings → Pages → Source** 가 `gh-pages` / `(root)` 로 되어 있어야 합니다.
`main`으로 되어 있으면 GitHub이 README를 Jekyll로 렌더해서 홈페이지로 내보냅니다.

### 주소를 바꾸려면

`_quarto.yml`의 `site-url` 한 줄입니다. 바꾼 뒤에는 **`_site/sitemap.xml`을 반드시
지우고** 전체 렌더를 하세요 — Quarto는 sitemap을 새로 만들지 않고 병합해서
옛 주소가 그대로 남습니다.

개인 도메인(예: `dongjunechoi.com`)을 붙일 경우, GitHub이 도메인을 기억하는
`CNAME` 파일이 `gh-pages` 브랜치에 있어야 하는데 `quarto publish`가 그 브랜치를
통째로 다시 씁니다. 프로젝트 루트에 `CNAME`을 두고 `_quarto.yml`의
`project: resources:`에 추가해야 매 배포마다 살아남습니다.

## 검색 노출 (Google)

`_quarto.yml`에 `site-url`이 있어서 빌드할 때 `sitemap.xml`과 `robots.txt`가
자동으로 생성됩니다.

검색 결과에 나오는 제목은 `_quarto.yml`의 `website: title:`입니다.
navbar에 보이는 짧은 이름은 `website: navbar: title:`로 따로 잡혀 있습니다.
**front matter의 `pagetitle`로는 바꿀 수 없습니다** (웹사이트 모드에서 무시됨).

### Search Console 소유권 확인 파일

Google이 주는 `googleXXXXXXXX.html`을 **프로젝트 루트**에 두고 배포하면 됩니다.
`_quarto.yml`의 `project: resources:`에 `"google*.html"`이 등록되어 있어
파일 이름이 무엇이든 `_site`로 복사됩니다.

```
1. googleXXXX.html 을 프로젝트 루트에 저장
2. quarto publish gh-pages
3. https://dj603.github.io/googleXXXX.html 이 열리는지 확인
4. Search Console 에서 "확인" 클릭
```

확인 후에도 파일을 지우지 마세요. Google이 주기적으로 다시 확인합니다.

### 그 다음

이름 검색 순위는 **백링크**가 좌우합니다. 사이트 설정보다 이쪽이 효과가 큽니다.

- OSU 수학과 people 페이지에 홈페이지 링크 요청
- Google Scholar 프로필의 Homepage 항목
- ORCID 프로필
- arXiv author 페이지

## 겪었던 함정

유지보수하다 밟은 것들은 `CLAUDE.md`의 "알려진 함정"에 모아 두었습니다.
특히 자주 걸리는 둘만 여기 적어 둡니다.

### 설치 직후 `quarto` 명령을 못 찾음

winget으로 설치한 뒤 **기존에 열려 있던 터미널에서는 PATH가 갱신되지 않습니다.**
터미널을 새로 열면 정상 동작합니다.

전체 경로로 직접 부르면 실패합니다 (배치 래퍼가 자기 경로의 공백을 처리하지 못합니다).
굳이 절대경로가 필요하면 8.3 단축 경로 `C:\PROGRA~1\Quarto\bin\quarto.cmd`를 쓰세요.

### 첫 페이지 이동 때 "Render" 흰 상자가 뜸

`quarto preview`로 띄운 뒤 처음으로 다른 페이지로 넘어가면 **"Render"라는 제목의
흰 상자**가 잠깐 떴다 사라집니다. 사이트 버그가 아니라 **미리보기 서버의 진행 표시창**이며,
**배포된 사이트에는 나타나지 않습니다.**

시작할 때 전부 렌더해 두면 보이지 않습니다.

```
quarto preview --render all
```

에러가 나면 같은 자리에 "Error"로 바뀌어 빌드 실패를 알려주므로, CSS나 JS로 숨기지 마세요.

## 참고

- Quarto 웹사이트 문서: <https://quarto.org/docs/websites/>
- 인용/서지: <https://quarto.org/docs/authoring/citations.html>
- GitHub Pages 배포: <https://quarto.org/docs/publishing/github-pages.html>
