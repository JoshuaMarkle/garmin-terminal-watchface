# Garmin Terminal Watchface

This is a simple terminal watchface inspired by [this r/unixporn post](https://www.reddit.com/r/unixporn/comments/9ndo8o/oc_always_keep_some_terminal_with_you/).

![screenshot.png](.github/screenshot.png)

## Building

> [!IMPORTANT]
> This watchface was designed specifically for the Forerunner 570 47mm (454px x 454px). The internal code could be modified to size correctly for other watchface sizes with changes to the text offset and text size. There are included smaller font sizes.

Download the [connectiq sdk](https://developer.garmin.com/connect-iq/sdk/).

If you want to simulate this watchface, I suggest downloading the official [monkeyc vscode extention](https://marketplace.visualstudio.com/items?itemName=garmin.monkey-c) but if you are like me and using some variant of Linux, then you could use the included `Makefile`.

## Modification

The font size can be changed

Most of the core code is within the `TerminalWatchFaceView.mc`. It handles the calculations and text rendering.

You can change the font size within this file to. Be default, the font size is 28px but I have included builds for 16, 24, 28, and 32 (look within `fonts.xml`).

- I have builds for Roboto Mono Medium using [fontbm](https://github.com/vladimirgamalyan/fontbm/releases/tag/v0.6.1).

For centering the text, the offset values are also within `TerminalWatchFaceView.mc` under the `// Offsets` section.
