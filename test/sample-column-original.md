---
indent: true
header-includes: |
  \usepackage{tcolorbox}
  \tcbuselibrary{xparse}
  \tcbuselibrary{skins}
  \tcbuselibrary{breakable}
include-before: |
  ```{=latex}
  \tcbset{
    breakable,
    enhanced,
    fonttitle=\bfseries,
    parbox=false,
    attach boxed title to top left={xshift=3mm, yshift*=-\tcboxedtitleheight/2},
  }
  
  \newtcolorbox{column}[1]{title=【コラム】{#1}}
  ```
---

<!-- 
\newtcolorbox{titlebox}[1]{%
    title=#1,
}
-->

`\begin{tcolorbox}`{=latex}
タイトルのない囲みです。
`\end{tcolorbox}`{=latex}

`\begin{tcolorbox}[title=タイトル付きの囲み]`{=latex}
タイトル付きの囲みです。
`\end{tcolorbox}`{=latex}

`\begin{tcolorbox}[title=■コラム: 何らかの小話]`{=latex}
タイトルの頭に`■コラム: `が付きます。
`\end{tcolorbox}`{=latex}

<!-- 
`\begin{column}{何らかの小話}`{=latex}
タイトルの頭に`【コラム】`が付きます。
`\end{column}`{=latex}
-->
