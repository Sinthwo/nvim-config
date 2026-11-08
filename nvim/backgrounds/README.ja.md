# Windows 用の背景画像

**言語：** [English](README.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | 日本語

このフォルダーまたはサブフォルダーに壁紙を配置してください。選択機能は PNG、JPG/JPEG、GIF、BMP、WebP に対応しています。付属画像の出典は[クレジット](CREDITS.ja.md)に記載されています。

[![画像の選択とお気に入りを表示する壁紙マネージャー](../../docs/screenshots/wallpapers.png)](../../docs/screenshots/wallpapers.png)

ほかの画面は[スクリーンショットギャラリー](../../docs/screenshots/README.ja.md)で確認できます。

## 壁紙を選ぶ

Neovim で次のコマンドまたはショートカットを使用します。

| コマンド | キー | 操作 |
| --- | --- | --- |
| `:BackgroundPick` | `Space u b` | 壁紙を選択 |
| `:BackgroundFolder` | `Space u B` | Windows エクスプローラーで画像フォルダーを開く |

`Space u b` で Wallpaper Manager を開きます。Browse wallpapers はフォルダー参照、Favorites はお気に入り、
Shuffle now は別の画像の選択、Settings は起動時の動作です。分類は `Anime/`、`Games/`、`Real World/`、`Other/`。
アニメ画像は `Anime/<作品名>/Images/`、アニメーションは `GIFs/` に置きます。
PNG、JPG/JPEG、GIF、BMP、WebP に対応し、SVG は対象外です。Snacks が使えない場合は `vim.ui.select` を使います。

### 起動モード

| モード | 動作 |
| --- | --- |
| `random`（初期設定） | 対話的な起動ごとに画像を選択。候補が複数あれば現在の画像を避ける |
| `random_favorite` | お気に入りから選択。登録が最低 1 件必要 |
| `manual` | 現在の画像を維持。画像を手動選択した場合もこのモードになる |

`:BackgroundMode random`、`:BackgroundMode random_favorite`、`:BackgroundMode manual` でモードを設定します。
ランダムモードを設定すると、画像をすぐに選びます。headless では起動時の画像変更を行いません。

| コマンド | 操作 |
| --- | --- |
| `:BackgroundRandom` | 一度だけランダム選択 |
| `:BackgroundFavorite` | 現在の画像のお気に入り登録を切り替え |
| `:BackgroundFavorites` | お気に入り一覧を開く |

この 3 コマンドは起動モードを変更しません。キャンセルしても画像とモードは変わりません。

### ローカルの選択情報

`background-mode.txt`、`favorite-backgrounds.txt`、`selected-background.txt` はローカル専用で Git が無視します。
お気に入りと選択は `Anime/Magi/Images/01-Magi-Friends-under-Starry-Sky.jpg` のような相対パスを使います。
以前の絶対パスも使用でき、書き直すと相対パスになります。

## 別の画像フォルダーを使う

既定のフォルダーは Neovim の `stdpath("config")` 内の `backgrounds` で、Windows では通常 `$env:LOCALAPPDATA\nvim\backgrounds` です。Neovim と WezTerm の `NVIM_BACKGROUND_DIR` を同じ絶対パス、またはホームからの相対パス `~/...` に設定してください。変数を変更したら両方のアプリケーションを再起動します。

永続的なユーザー設定には次の PowerShell ブロックを実行し、フォルダーに画像を追加してから、
WezTerm と Neovim を完全に再起動して値を反映させてください。

```powershell
$backgroundDir = Join-Path $HOME 'Pictures\Terminal Backgrounds'
New-Item -ItemType Directory -Path $backgroundDir -Force -ErrorAction Stop | Out-Null
[Environment]::SetEnvironmentVariable('NVIM_BACKGROUND_DIR', $backgroundDir, 'User')
```

## WezTerm に壁紙を表示する

付属の [`WezTerminal-Config/.wezterm.lua`](../../WezTerminal-Config/.wezterm.lua) を `$HOME\.wezterm.lua` に配置してください。WezTerm は選択を読み込み、Neovim の使用中に暗くした壁紙を表示します。ターミナルウィンドウは不透明で、文字を読みやすくするため画像を暗くします。

選択が空、または画像がない場合は、通常のターミナル表示に戻ります。

[Windows マニュアル](../../MANUAL.ja.md#wezterm-と壁紙)と[現在の画像の出典](CREDITS.ja.md)をご覧ください。
