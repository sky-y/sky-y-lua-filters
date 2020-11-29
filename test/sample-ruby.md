# LaTeXのルビ用フィルタ

下記のLaTeXパッケージに依存する。

- pxrubrica
    - `\usepackage{pxrubrica}` をヘッダ（プリアンブル）に読み込む
    - 詳細
        - [LaTeX 文書で“美しい日本の”ルビを使う ～pxrubrica パッケージ～ - Qiita](https://qiita.com/zr_tex8r/items/42466cbcbeb670a3a2dc)
        - マニュアル [pxrubrica パッケージ](http://texdoc.net/texmf-dist/doc/platex/pxrubrica/pxrubrica.pdf)

※ luatexja-ruby パッケージには非対応。

## 構文

    [親文字](ルビ文字){.ruby}
    [alphabet](欧文ルビ文字){.aruby}  ※ pxrubricaのみ

オプションはPandoc's Markdownの属性(attribute)として与える。
オプションの構文自体は両パッケージとも共通に使える。

構文（Pandoc's Markdown）：

    [親文字](ルビ){.ruby opt="オプション"}

たとえば

    [雲雀](ひばり){.ruby opt="g"}

は

    \ruby[g]{雲雀}{ひばり}

に変換される。

## 例

### 例1

Markdown：

    あれは[鷹](たか){.ruby}ではなく[鶯](うぐいす){.ruby}です。

出力結果：

あれは[鷹](たか){.ruby}ではなく[鶯](うぐいす){.ruby}です。

### 例2

Markdown：

    [小鳩](こ|ばと){.ruby} [孔雀](く|じゃく){.ruby} [七面鳥](しち|めん|ちょう)

出力結果：

[小鳩](こ|ばと){.ruby} [孔雀](く|じゃく){.ruby} [七面鳥](しち|めん|ちょう){.ruby}

### 例3（圏点）

Markdown：

    [本質]{.kenten}

出力結果：

[本質]{.kenten}

### 例4（グループルビ）

Markdown：

    [雲雀](ひ|ばり){.ruby opt="g"} [不如帰](ほととぎす){.ruby opt="g"}

出力結果：

[雲雀](ひばり){.ruby opt="g"} [不如帰](ほととぎす){.ruby opt="g"}

### 例5（モノルビ）

Markdown：

    [孔雀](く|じゃく){.ruby opt="m"} [七面鳥}(しち|めん|ちょう){.ruby opt="m"}

出力結果：

[孔雀](く|じゃく){.ruby opt="m"} [七面鳥}(しち|めん|ちょう){.ruby opt="m"}

## 例6（`\aruby`：欧文用のルビ）

pxrubricaにおける`\aruby`（欧文用のルビ）の構文も用意している。

構文：

    [alphabet](ルビ){.aruby}

Markdown：

    [Pandoc](パンドック){.aruby}と[Markdown](マークダウン){.aruby}

出力結果：

[Pandoc](パンドック){.aruby}と[Markdown](マークダウン){.aruby}

注意：`\truby`や`\atruby`などは提供しない。