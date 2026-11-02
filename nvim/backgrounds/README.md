# Background images for Windows

**Languages:** English | [Français](README.fr.md) | [Deutsch](README.de.md) | [日本語](README.ja.md)

Put your wallpapers in this folder or its subfolders. The picker supports PNG,
JPG/JPEG, GIF, BMP, and WebP files. Sources for the included images are listed
in [CREDITS.md](CREDITS.md).

## Choose a wallpaper

Inside Neovim, use these commands or shortcuts:

| Command | Keys | Action |
| --- | --- | --- |
| `:BackgroundPick` | Space u b | Choose a wallpaper |
| `:BackgroundFolder` | Space u B | Open the image folder in Windows Explorer |

Space u b opens the Wallpaper Manager. Browse one folder at a time, use
Favorites to add or remove stars, Shuffle now to choose another image, and
Settings to choose startup behavior. The categories are `Anime/`, `Games/`,
`Real World/`, and `Other/`. Anime images live in `Anime/<title>/Images/`, with
`GIFs/` reserved for animations. PNG, JPG/JPEG, GIF, BMP, and WebP are supported.
The manager uses the Snacks picker, with `vim.ui.select` as a fallback; SVG is excluded.

The default mode is `random`: each interactive startup selects another image,
avoiding the current image when alternatives exist. `random_favorite` chooses
only favorites and requires at least one. `manual` keeps the selection; choosing
an image manually also selects this mode. Startup rotation is skipped in headless
sessions. `:BackgroundMode random`, `:BackgroundMode random_favorite`, and
`:BackgroundMode manual` change the mode and immediately apply random modes.
`:BackgroundRandom` shuffles once, `:BackgroundFavorite` stars/unstars the active
image, and `:BackgroundFavorites` browses favorites. These three commands keep
the current startup mode.

`background-mode.txt`, `favorite-backgrounds.txt`, and `selected-background.txt`
are local, Git-ignored files. Favorites and selections use relative image paths.
Older absolute records are accepted locally and become relative when rewritten.
Cancelling a menu leaves the current image and mode unchanged.

Your choice is saved in `selected-background.txt` as a **relative image path**,
such as `Anime/Magi/Images/01-Magi-Friends-under-Starry-Sky.jpg`. Git ignores this generated file. Cancelling
the picker keeps your previous choice.

## Use a different image folder

The default folder is Neovim's `stdpath("config")` plus `backgrounds`, normally
`$env:LOCALAPPDATA\nvim\backgrounds` on Windows. Set `NVIM_BACKGROUND_DIR` to the
same absolute directory, or the same `~/...` home-relative directory, in
Neovim and WezTerm. Restart both applications after changing the variable.

## Display the wallpaper in WezTerm

Install the included
[`WezTerminal-Config/.wezterm.lua`](../../WezTerminal-Config/.wezterm.lua)
at `$HOME\.wezterm.lua`. WezTerm reads your selection and displays a darkened
wallpaper while Neovim is active. The terminal window stays opaque, and the
image is dimmed to keep text readable.

An empty selection or a missing image restores the normal terminal appearance.
Older selections that contain an absolute path still work locally. Choosing
another wallpaper replaces that path with a relative one.

See the [Windows manual](../../MANUAL.md#wezterm-and-wallpapers) and the
[current image sources](CREDITS.md).

## Images and sources

Every current image in this folder is linked below. Some recorded source links
lead to a wallpaper search page rather than an individual image or its artist.
Other images have no recorded source page.

| Image | Recorded source |
| --- | --- |
| [Agents of the Four Seasons: cherry blossoms](<Anime/Agents of the Four Seasons Dance of Spring/Images/01-Agents-of-the-Four-Seasons-Dance-of-Spring-Cherry-Blossoms.jpg>) | Source not recorded |
| [Agents of the Four Seasons Dance of Spring: Spring dance alternate](<Anime/Agents of the Four Seasons Dance of Spring/Images/02-Agents-of-the-Four-Seasons-Dance-of-Spring-Spring-Dance-Alternate.png>) | [Source](https://www.anime-atelier.com/agents-of-the-four-seasons-dance-of-spring-anime/) |
| [Agents of the Four Seasons Dance of Spring: Four seasons visual](<Anime/Agents of the Four Seasons Dance of Spring/Images/03-Agents-of-the-Four-Seasons-Dance-of-Spring-Four-Seasons-Visual.jpg>) | [Source](https://www.themoviedb.org/) |
| [Agents of the Four Seasons Dance of Spring: Spring and winter poster](<Anime/Agents of the Four Seasons Dance of Spring/Images/04-Agents-of-the-Four-Seasons-Dance-of-Spring-Spring-Winter-Poster.jpg>) | [Source](https://www.themoviedb.org/) |
| [Attack on Titan: Founding Titan and the Rumbling (4K)](<Anime/Attack on Titan/Images/01-Attack-on-Titan-Founding-Titan-Rumbling-4K.jpg>) | Source not recorded |
| [Attack on Titan: Founding Titan and the Rumbling (1080p)](<Anime/Attack on Titan/Images/02-Attack-on-Titan-Founding-Titan-Rumbling-1080p.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1218892) |
| [Attack on Titan: Eren in a flower field](<Anime/Attack on Titan/Images/03-Attack-on-Titan-Eren-in-Flower-Field.jpg>) | Source not recorded |
| [Attack on Titan: Anya behind the Wall](<Anime/Attack on Titan/Images/04-Attack-on-Titan-Anya-Behind-the-Wall.jpg>) | [UHD Paper Attack on Titan search](https://www.uhdpaper.com/search?q=Attack+on+Titan&by-date=true) |
| [Attack on Titan: Eren above the clouds](<Anime/Attack on Titan/Images/05-Attack-on-Titan-Eren-Above-the-Clouds.png>) | [Alpha Coders Attack on Titan gallery](https://alphacoders.com/attack-on-titan-wallpapers) |
| [Attack on Titan: Founding Titan red silhouette](<Anime/Attack on Titan/Images/06-Attack-on-Titan-Founding-Titan-Red-Silhouette.jpg>) | [UHD Paper image page](https://www.uhdpaper.com/2022/01/founding-titan-attack-on-titan-4k-2980f.html?m=0) |
| [Attack on Titan: Mikasa sketch](<Anime/Attack on Titan/Images/07-Attack-on-Titan-Mikasa-Sketch.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=463623) |
| [Attack on Titan: scouts at twilight](<Anime/Attack on Titan/Images/08-Attack-on-Titan-Scouts-at-Twilight.jpg>) | [Alpha Coders Attack on Titan gallery](https://alphacoders.com/attack-on-titan-wallpapers) |
| [Attack on Titan: Wall at sunset](<Anime/Attack on Titan/Images/09-Attack-on-Titan-Wall-at-Sunset.jpg>) | [Wallpaper Alchemy image page](https://www.wallpaperalchemy.com/wallpaper/attack-on-titan-sunset-city-walls-4k-wallpaper-1788) |
| [Black Clover: Asta Demon Form](<Anime/Black Clover/Images/01-Black-Clover-Asta-Demon-Form.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=910284) |
| [Black Clover: Asta Yuno Minimal](<Anime/Black Clover/Images/02-Black-Clover-Asta-Yuno-Minimal.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=964809) |
| [Black Clover: Asta Unleashed Dark](<Anime/Black Clover/Images/03-Black-Clover-Asta-Unleashed-Dark.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=983332) |
| [Bleach: Ichigo Bankai](<Anime/Bleach/Images/01-Bleach-Ichigo-Bankai.png>) | Source not recorded |
| [Bleach: Ichigo in moonlight](<Anime/Bleach/Images/02-Bleach-Ichigo-Moonlight.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=1319289) |
| [Bleach: Thousand-Year Blood War minimal text](<Anime/Bleach/Images/03-Bleach-TYBW-Minimal-Text.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=1392231) |
| [Bleach: Mayuri Bankai](<Anime/Bleach/Images/04-Bleach-Mayuri-Bankai.png>) | [Source](https://wall.alphacoders.com/big.php?i=1384147) |
| [Cyberpunk Edgerunners: David Lucy Night City](<Anime/Cyberpunk Edgerunners/Images/01-Cyberpunk-Edgerunners-David-Lucy-Night-City.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1330457) |
| [Cyberpunk Edgerunners: Adam Smasher Dark](<Anime/Cyberpunk Edgerunners/Images/02-Cyberpunk-Edgerunners-Adam-Smasher-Dark.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1276564) |
| [Cyberpunk Edgerunners: David Lucy Cityscape](<Anime/Cyberpunk Edgerunners/Images/03-Cyberpunk-Edgerunners-David-Lucy-Cityscape.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1406881) |
| [Demon Slayer: Tanjiro Water Fire](<Anime/Demon Slayer/Images/01-Demon-Slayer-Tanjiro-Water-Fire.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1206472) |
| [Demon Slayer: Upper Moons Dark](<Anime/Demon Slayer/Images/02-Demon-Slayer-Upper-Moons-Dark.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1362372) |
| [Demon Slayer: Purple Wisteria](<Anime/Demon Slayer/Images/03-Demon-Slayer-Purple-Wisteria.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1362341) |
| [Fairy Tail: Magic Edit](<Anime/Fairy Tail/Images/01-Fairy-Tail-Magic-Edit.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=735710) |
| [Fairy Tail: Blue Magic](<Anime/Fairy Tail/Images/02-Fairy-Tail-Blue-Magic.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=735663) |
| [Fairy Tail: Purple Magic](<Anime/Fairy Tail/Images/03-Fairy-Tail-Purple-Magic.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=735674) |
| [Fruits Basket: Kyo and Tohru in the classroom](<Anime/Fruits Basket/Images/01-Fruits-Basket-Kyo-and-Tohru-in-Classroom.png>) | Source not recorded |
| [Fruits Basket: Character collage](<Anime/Fruits Basket/Images/02-Fruits-Basket-Character-Collage.png>) | [Source](https://wall.alphacoders.com/big.php?i=1176239) |
| [Fruits Basket: Tohru and cat minimal art](<Anime/Fruits Basket/Images/03-Fruits-Basket-Tohru-and-Cat-Minimal.png>) | [Source](https://wall.alphacoders.com/big.php?i=1002898) |
| [Fruits Basket: Zodiac cast portrait](<Anime/Fruits Basket/Images/04-Fruits-Basket-Zodiac-Cast-Portrait.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=1160386) |
| [Just Because!: train platform](<Anime/Just Because!/Images/01-Just-Because-Train-Platform.jpeg>) | Source not recorded |
| [Just Because!: Train platform alternate](<Anime/Just Because!/Images/02-Just-Because-Train-Platform-Alternate.png>) | [Source](https://wall.alphacoders.com/big.php?i=891655) |
| [Just Because!: Three girls pink artwork](<Anime/Just Because!/Images/03-Just-Because-Three-Girls-Pink-Artwork.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=1048718) |
| [Just Because!: City sunset](<Anime/Just Because!/Images/04-Just-Because-City-Sunset.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=1048741) |
| [Love Unseen Beneath the Clear Night Sky: fireworks](<Anime/Love Unseen Beneath the Clear Night Sky/Images/01-Love-Unseen-Beneath-the-Clear-Night-Sky-Fireworks.jpg>) | Source not recorded |
| [Love Unseen Beneath the Clear Night Sky: Couple under a blue sky](<Anime/Love Unseen Beneath the Clear Night Sky/Images/02-Love-Unseen-Beneath-the-Clear-Night-Sky-Couple-Blue-Sky.jpg>) | [Source](https://animecorner.me/love-unseen-beneath-the-clear-night-sky-anime-unveils-key-visual/) |
| [Love Unseen Beneath the Clear Night Sky: Nighttime meeting](<Anime/Love Unseen Beneath the Clear Night Sky/Images/03-Love-Unseen-Beneath-the-Clear-Night-Sky-Nighttime-Meeting.jpg>) | [Source](https://www.animeclick.it/anime/65679/love-unseen-beneath-the-clear-night-sky) |
| [Magi: friends under the stars](<Anime/Magi/Images/01-Magi-Friends-under-Starry-Sky.jpg>) | Source not recorded |
| [Magi: Sinbad and friends](<Anime/Magi/Images/02-Magi-Sinbad-and-Friends.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=748611) |
| [Magi: Aladdin and Alibaba](<Anime/Magi/Images/03-Magi-Aladdin-and-Alibaba.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=735490) |
| [Magi: Aladdin, Alibaba, and Morgiana under a blue sky](<Anime/Magi/Images/04-Magi-Aladdin-Alibaba-Morgiana-Blue-Sky.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=748610) |
| [My Teen Romantic Comedy SNAFU: Yukino in the rain](<Anime/My Teen Romantic Comedy SNAFU/Images/01-My-Teen-Romantic-Comedy-SNAFU-Yukino-in-Rain.jpeg>) | Source not recorded |
| [My Teen Romantic Comedy SNAFU: Hachiman collage](<Anime/My Teen Romantic Comedy SNAFU/Images/02-My-Teen-Romantic-Comedy-SNAFU-Hachiman-Collage.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=1014185) |
| [My Teen Romantic Comedy SNAFU: Main trio](<Anime/My Teen Romantic Comedy SNAFU/Images/03-My-Teen-Romantic-Comedy-SNAFU-Main-Trio.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=1058849) |
| [My Teen Romantic Comedy SNAFU: Soubu band](<Anime/My Teen Romantic Comedy SNAFU/Images/04-My-Teen-Romantic-Comedy-SNAFU-Soubu-Band.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=657368) |
| [Ranking of Kings: Bojji and Kage by the castle](<Anime/Ranking of Kings/Images/01-Ranking-of-Kings-Bojji-and-Kage-by-Castle.jpg>) | Source not recorded |
| [Ranking of Kings: Bojji and Kage by the castle alternate](<Anime/Ranking of Kings/Images/02-Ranking-of-Kings-Bojji-and-Kage-by-Castle-Alternate.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=1191503) |
| [Ranking of Kings: Bojji and Kage viewing the castle](<Anime/Ranking of Kings/Images/03-Ranking-of-Kings-Bojji-and-Kage-Castle-View.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=1186483) |
| [Ranking of Kings: Bojji minimal 4K](<Anime/Ranking of Kings/Images/04-Ranking-of-Kings-Bojji-Minimal-4K.png>) | [Source](https://wall.alphacoders.com/big.php?i=1205803) |
| [Seraph of the End: Manga Cover Art](<Anime/Seraph of the End/Images/01-Seraph-of-the-End-Manga-Cover-Art.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1008224) |
| [Seraph of the End: Yuichiro Artwork](<Anime/Seraph of the End/Images/02-Seraph-of-the-End-Yuichiro-Artwork.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=963294) |
| [Seraph of the End: Yuichiro Sword](<Anime/Seraph of the End/Images/03-Seraph-of-the-End-Yuichiro-Sword.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=629541) |
| [The Eminence in Shadow: Cid Dark](<Anime/The Eminence in Shadow/Images/01-The-Eminence-in-Shadow-Cid-Dark.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1335155) |
| [The Eminence in Shadow: Red Moon Duel](<Anime/The Eminence in Shadow/Images/02-The-Eminence-in-Shadow-Red-Moon-Duel.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1337181) |
| [The Eminence in Shadow: Cid Minimal](<Anime/The Eminence in Shadow/Images/03-The-Eminence-in-Shadow-Cid-Minimal.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1286624) |
| [The God Of High School: Jin Mori 5K](<Anime/The God Of High School/Images/01-The-God-Of-High-School-Jin-Mori-5K.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1092991) |
| [The God Of High School: Jin Mori 4K](<Anime/The God Of High School/Images/02-The-God-Of-High-School-Jin-Mori-4K.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1143430) |
| [The God Of High School: Main Characters](<Anime/The God Of High School/Images/03-The-God-Of-High-School-Main-Characters.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1092988) |
| [Violet Evergarden: Violet Blue Sky](<Anime/Violet Evergarden/Images/01-Violet-Evergarden-Violet-Blue-Sky.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1030524) |
| [Violet Evergarden: Violet Red Sunset](<Anime/Violet Evergarden/Images/02-Violet-Evergarden-Violet-Red-Sunset.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=994926) |
| [Violet Evergarden: Violet Cityscape](<Anime/Violet Evergarden/Images/03-Violet-Evergarden-Violet-Cityscape.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1161011) |
| [Your Lie in April: Kaori and Kosei performing](<Anime/Your Lie in April/Images/01-Your-Lie-in-April-Kaori-and-Kosei-Performing.png>) | Source not recorded |
| [Your Lie in April: Piano under a blue sky](<Anime/Your Lie in April/Images/02-Your-Lie-in-April-Piano-Blue-Sky.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=832516) |
| [Your Lie in April: Kaori and Kosei minimal art](<Anime/Your Lie in April/Images/03-Your-Lie-in-April-Kaori-and-Kosei-Minimal.png>) | [Source](https://wall.alphacoders.com/big.php?i=673630) |
| [Your Lie in April: Kaori and Kosei under a starry night](<Anime/Your Lie in April/Images/04-Your-Lie-in-April-Kaori-and-Kosei-Starry-Night.jpg>) | [Source](https://wall.alphacoders.com/big.php?i=832572) |
| [Your Name: Meteor Starfall](<Anime/Your Name/Images/01-Your-Name-Meteor-Starfall.jpg>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=774989) |
| [Your Name: Mitsuha Taki Portraits](<Anime/Your Name/Images/02-Your-Name-Mitsuha-Taki-Portraits.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=773551) |
| [Your Name: Comet Tiamat](<Anime/Your Name/Images/03-Your-Name-Comet-Tiamat.png>) | [Alpha Coders image page](https://wall.alphacoders.com/big.php?i=1350497) |
