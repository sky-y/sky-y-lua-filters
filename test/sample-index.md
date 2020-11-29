## 準備

テンプレート変数として、次のヘッダ（プリアンブル）を読み込む。

```
\usepackage{makeidx}
\makeindex
```

- パターン1：ヘッダファイルとして読み込む
    - `pandoc ... -H header.tex`
- パターン2：コマンドラインで直接指定する
    - `pandoc ... -V header-includes="\usepackage{makeidx}" -V header-includes="\makeindex"`
- パターン3：デフォルトファイルに指定する
    - `pandoc ... -d defaults.yaml`

```
variables:
  header-includes: |
    \usepackage{makeidx}
    \makeindex
```

## 注意

テンプレート変数の指定が重複する場合は要注意。

- テンプレート変数同士は、重ねると追記される（上書きしない）
    - ヘッダファイル読み込み（`-H`/`--include-in-header`）でも、変数の直接指定（`-V header-includes=`）でも同じ
    - 同じヘッダ内容を複数回読まないように注意
- メタデータとテンプレートの組み合わせでは、テンプレートがメタデータを上書きする

## 例

1 [Pandoc]{.index}

2 [Pandoc's Markdown]{.index}

3 [けいおん!]{.index}

4 [aaa@bbb]{.index}

5 [ccc|ddd]{.index}

6 [免疫](めんえき){.index}

7(only) [LaTeX]{.index .only}

8(only) [変数](へんすう){.index .only}

9 [mendex]{.index}

10(raw) mendexの使い方[mendex!のつかいかた@---の使い方]{.index .raw}

11(keyword) [Markdown]{.keyword}

12(keyword) [技術書典](ぎじゅつしょてん){.keyword}

13 [--standalone]{.index}

14(code) [--template]{.index .code}

15(code only) [--lua-filter]{.index .code .only}

16(raw\_tex) --filter\index{--filter@\texttt{--filter}}

17(only) `\scsnowman[snow,hat=true,muffler=red,arms=true,scale=3]`{=latex}[](本質){.index .only} 

::: printindex
:::
