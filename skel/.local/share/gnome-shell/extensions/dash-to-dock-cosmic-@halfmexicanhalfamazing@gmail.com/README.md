# Dash to Dock for Pop!_OS
![screenshot](https://github.com/halfmexican/dash-to-dock-pop/blob/ubuntu-dock/media/screenshot.jpg)

This extensions aims to provide a more customizable dock for Pop! OS, other dock extensions have conflicts with Cosmic Workspaces causes elements of the COSMIC/GNOME shell to break. This extensions removes conflicts and extends functionality. 


# Installation

Go to releases and download the code. A simple Makefile is included. Extract and run the make file. Instructions Below!


[<img src="https://micheleg.github.io/dash-to-dock/media/get-it-on-ego.png" height="100">](https://extensions.gnome.org/extension/5004/dash-to-dock-for-cosmic/)

or click above to download from gnome extensions. Latest Version will appear on github!

### Build Dependencies

To compile the stylesheet you'll need an implementation of SASS. Dash to Dock supports `dart-sass` (`sass`), `sassc`, and `ruby-sass`. Every distro should have at least one of these implementations, we recommend using `dart-sass` (`sass`) or `sassc` over `ruby-sass` as `ruby-sass` is deprecated.

By default, Dash to Dock will attempt to build with `sassc`. To change this behavior set the `SASS` environment variable to either `dart` or `ruby`.

```bash
export SASS=dart
# or...
export SASS=ruby
```
make sure you have gettext installed with

```bash
sudo apt install gettext
```

### Building

Next use `make` to install the extension into your home directory. A Shell reload is required `Alt+F2 r Enter` under Xorg or under Wayland you may have to logout and login. The extension has to be enabled  with *gnome-extensions-app* (GNOME Extensions) or with *dconf*.

Make sure to disable Cosmic Dock

```bash
make
make install
```

## License
Dash to Dock Gnome Shell extension is distributed under the terms of the GNU General Public License,
version 2 or later. See the COPYING file for details.
