# Luaフィルタ関連

## オリジナルLuaフィルタ

使用例はそれぞれのluaファイルのコメントを参照。

- tcolorbox-column.lua
    - 囲み・コラム
- luatexja-ruby.lua
    - ルビ (luatexja-ruby パッケージ準拠)
- latex-index.lua
    - 索引 (upmendex 準拠)
- utils.lua
    - 上記が依存するユーティリティ関数

## 外部Luaフィルタ

- 公式の Lua Filters ([pandoc/lua-filters](https://github.com/pandoc/lua-filters) )
    - [include-code-files](https://github.com/pandoc/lua-filters/tree/master/include-code-files)
        - ソースコードをPandoc's Markdownに取り込むフィルタ
- [jagt/pprint.lua](https://github.com/jagt/pprint.lua)
    - 変数をダンプ (デバッグ用)

## その他のファイル

- munepi-index.ist/tex
    - LaTeXの索引スタイル (munepiさん)
    - [ぼくのかんがえたさいきょうのLaTeX索引スタイルファイル - Qiita](https://qiita.com/munepi/items/2e1524859e24b5fb44bc)

# Todo

- [x] ルビフィルタ
- [x] 索引フィルタ
- [x] デバッグ
    - [x] ルビフィルタを適用すると索引が消えてしまう問題
    - [ ] `\index` のエスケープ文字問題：特定文字を置換する
- [ ] コラム（tcolorbox）

## トラブルシューティング

問題の切り分けを推奨します。

- Pandocの問題：`-t latex`でソースのみを出力してみる
- LaTeXの問題：Pandocから出力したソースを単品で`lualatex`にかけてみる

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
