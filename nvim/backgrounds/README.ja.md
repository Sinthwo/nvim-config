# Windows 用の背景画像

**言語：** [English](README.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | 日本語

このフォルダーまたはサブフォルダーに壁紙を配置してください。選択機能は PNG、JPG/JPEG、GIF、BMP、WebP に対応しています。付属画像の出典は[クレジット](CREDITS.ja.md)に記載されています。

壁紙コレクションの入れ替えにより、[ThePrimeagen/anime](https://github.com/ThePrimeagen/anime) の画像は削除されました。クレジットには以前のコレクションへのリンクが残っています。

## 壁紙を選ぶ

Neovim で次のコマンドまたはショートカットを使用します。

| コマンド | キー | 操作 |
| --- | --- | --- |
| `:BackgroundPick` | Space u b | 壁紙を選択 |
| `:BackgroundFolder` | Space u B | Windows エクスプローラーで画像フォルダーを開く |

Space u b で Wallpaper Manager を開きます。Browse wallpapers はフォルダー参照、Favorites はお気に入り、
Shuffle now は別の画像の選択、Settings は起動時の動作です。分類は `Anime/`、`Games/`、`Real World/`、`Other/`。
アニメ画像は `Anime/<作品名>/Images/`、アニメーションは `GIFs/` に置きます。
PNG、JPG/JPEG、GIF、BMP、WebP に対応し、SVG は対象外です。Snacks が使えない場合は `vim.ui.select` を使います。

初期モードは `random` で、対話的な起動ごとに画像を選びます。候補が複数あれば現在の画像を避けます。
`random_favorite` はお気に入りのみを使い、登録が最低 1 件必要です。`manual` は現在の画像を維持します。
画像を手動選択した場合も manual になります。headless では起動時の画像変更を行いません。
`:BackgroundMode random`、`:BackgroundMode random_favorite`、`:BackgroundMode manual` でモードを設定します。
ランダムモードの設定時には画像をすぐ選びます。`:BackgroundRandom` は一度だけランダム選択し、
`:BackgroundFavorite` は現在の画像のお気に入り登録を切り替え、`:BackgroundFavorites` は一覧を開きます。
この 3 コマンドは起動モードを変更しません。

`background-mode.txt`、`favorite-backgrounds.txt`、`selected-background.txt` はローカル専用で Git が無視します。
お気に入りと画像選択は相対パスを使います。以前の絶対パスも読み込み、書き直すと相対パスになります。
メニューをキャンセルしても画像とモードは変わりません。

選択は `Anime/Magi/Images/01-Magi-Friends-under-Starry-Sky.jpg` のような **画像の相対パス** として `selected-background.txt` に保存されます。この生成ファイルは Git が無視します。キャンセルすると以前の選択を保持します。

## 別の画像フォルダーを使う

既定のフォルダーは Neovim の `stdpath("config")` 内の `backgrounds` で、Windows では通常 `$env:LOCALAPPDATA\nvim\backgrounds` です。Neovim と WezTerm の `NVIM_BACKGROUND_DIR` を同じ絶対パス、またはホームからの相対パス `~/...` に設定してください。変数を変更したら両方のアプリケーションを再起動します。

## WezTerm に壁紙を表示する

付属の [`WezTerminal-Config/.wezterm.lua`](../../WezTerminal-Config/.wezterm.lua) を `$HOME\.wezterm.lua` に配置してください。WezTerm は選択を読み込み、Neovim の使用中に暗くした壁紙を表示します。ターミナルウィンドウは不透明で、文字を読みやすくするため画像を暗くします。

選択が空、または画像がない場合は、通常のターミナル表示に戻ります。以前の絶対パスの選択もローカルでは使用できます。別の壁紙を選ぶと相対パスに置き換わります。

[Windows マニュアル](../../MANUAL.ja.md#wezterm-と壁紙)と[現在の画像の出典](CREDITS.ja.md)をご覧ください。
