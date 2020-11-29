# Luaフィルタ tcolorbox-column.lua の例

    ::: box
    タイトルのない囲みです。
    :::

::: box
タイトルのない囲みです。
:::

    ::: {.box title=タイトル付きの囲み}
    タイトル付きの囲みです。
    :::

::: {.box title=タイトル付きの囲み}
タイトル付きの囲みです。
:::

    ::: {.column title="何らかの小話"}
    タイトルの頭に `■コラム: ` （または`column-prefix`メタデータで指定された文字列）が付きます。
    :::

::: {.column title="何らかの小話"}
タイトルの頭に `■コラム: ` （または`column-prefix`メタデータで指定された文字列）が付きます。
:::

    ::: {.column title="何らかの小話" option="colbacktitle=black"}
    オプション付きです。
    :::

::: {.column title="何らかの小話" option="colbacktitle=black"}
オプション付きです。
:::
