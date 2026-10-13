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

選択画面はこのフォルダーとサブフォルダーを検索します。利用できる場合は Snacks の選択メニュー、それ以外は Neovim 内蔵の選択画面を使います。SVG は一覧に表示されません。

選択は `Magi/01-Magi-Star.jpg` のような **画像の相対パス** として `selected-background.txt` に保存されます。この生成ファイルは Git が無視します。キャンセルすると以前の選択を保持します。

## 別の画像フォルダーを使う

既定のフォルダーは Neovim の `stdpath("config")` 内の `backgrounds` で、Windows では通常 `$env:LOCALAPPDATA\nvim\backgrounds` です。Neovim と WezTerm の `NVIM_BACKGROUND_DIR` を同じ絶対パス、またはホームからの相対パス `~/...` に設定してください。変数を変更したら両方のアプリケーションを再起動します。

## WezTerm に壁紙を表示する

付属の [`WezTerminal-Config/.wezterm.lua`](../../WezTerminal-Config/.wezterm.lua) を `$HOME\.wezterm.lua` に配置してください。WezTerm は選択を読み込み、Neovim の使用中に暗くした壁紙を表示します。ターミナルウィンドウは不透明で、文字を読みやすくするため画像を暗くします。

選択が空、または画像がない場合は、通常のターミナル表示に戻ります。以前の絶対パスの選択もローカルでは使用できます。別の壁紙を選ぶと相対パスに置き換わります。

[Windows マニュアル](../../MANUAL.ja.md#wezterm-と壁紙)と[現在の画像の出典](CREDITS.ja.md)をご覧ください。
