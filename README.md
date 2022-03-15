# Zettelkasten sketch

This is a script thet works in conjunction with [Mickael Menu's
zk](https://github.com/mickael-menu/zk) only for MacOs. It opens the iPad
continuous sketch and copies the file into a demanded folder in the slipbox.

### Installation

There are two scripts present `sketch.sh` and `sketch.scpt`. Copy both into the
scripts folder inside the `zk` config (I chose this folder here). Or simply
`make install`, which copies the two files.

Finally add the following alias to `.zk/config.toml`
```
sketch = "$ZK_NOTEBOOK_DIR/.zk/scripts/sketch.sh [-i] [-f assets] [-t 10m]"
```
Three options are possible to set:
- `-i` inverts the luminance of the sketch (for dark backgrounds)
- `-f` sets the folder of the assets (default `assets`)
- `-t` sets the timeout for waiting for the sketch (default `10m`)

Now the command `zk sketch` is available to you.

### Functioning principle

Unfortunately, the continous integration feature is not well documented for
developers. So I chose a rather extreme apporach, by controlling the Mac with
apple script. First Finder gets opened in the root dir, then applescript selects
the `asset` folder and opens the context menu, where it chooses `Import from
iPad > Add sketch`.

The sketch-pad should open on the iPad. Draw your sketch and hit `Done`. The
file gets transferred into the `assets` folder. The sketch gets automatically
renamed and optinally luminance inverted for better contrast on dark
backgrounds.

### Example

On the Mac ![](./assets/mac.gif)
On the iPad ![](./assets/ipad.gif)

### LICENSE

GPLv3
