# 自作 Pandoc Luaフィルタ by sky-y

使用例はそれぞれのluaファイルのコメント、およびtestディレクトリのファイルを参照。

- tcolorbox-column.lua
    - 囲み・コラム
- pxrubrica-ruby.lua
    - ルビ (pxrubrica パッケージ準拠)
- latex-index.lua
    - 索引 (upmendex 準拠)
- utils.lua
    - ユーティリティ関数（上記フィルタを実際に使う際には不要）

## 外部のLuaフィルタ

- [jagt/pprint.lua](https://github.com/jagt/pprint.lua)
    - 変数をダンプ (デバッグ用)
    - public domain

## トラブルシューティング

Pandoc側で構文エラーを検出できないため、エラー時はLaTeX側でエラーになることがほとんどです。
問題が起こった際は、問題の切り分けを推奨します。

- `-t latex`でLaTeXソースのみを出力してみる
    - 表示されるエラー番号は、たいていの場合LaTeXソースの方です
- そのLaTeXソースを単品で`lualatex`に読み込ませてみる

### Q: PDF出力中に無限ループになる

- 可能性1: 括弧が間違っている
    - 大括弧 `[ ]` と中括弧  `{ }` と小括弧 `( )` を間違えていませんか？
    - Span形式: `[大括弧]{.class}` 
    - Link形式: `[大括弧](小括弧){.class}`
- 可能性2: LaTeX側の索引の記法が間違っている
    - 索引の記法は mendex (upmendex) に準じます
    - 記号のエスケープが必要かもしれません
        - before: `' % &`
            - after: `\' \% \&` (バックスラッシュエスケープ)
        - before: `@ ! |` (mendexにおいて特殊な文字)
            - after: `"@ "! "|` (ダブルクォートでエスケープ)
            - see: [QA: 索引で%や&などの文字を表示させるには](https://oku.edu.mie-u.ac.jp/tex/mod/forum/discuss.php?d=2508)
- 可能性3: フィルタのバグかもしれません
