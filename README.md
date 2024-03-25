# Steam WineASIO Flatpak 🎸✨ <!-- omit in toc -->

WineASIO extension for [Steam Flatpak](https://github.com/flathub/com.valvesoftware.Steam),
built as a patch on top of [Wine Flatpak](https://github.com/flathub/org.winehq.Wine).

Simple low-latency audio setup for [Rocksmith 2014](https://www.protondb.com/app/221680) under Linux!


## Contents <!-- omit in toc -->

<!-- vscode: ext install yzhang.markdown-all-in-one -->
- [Goals](#goals)
- [How to Build](#how-to-build)
  - [Install Dependencies](#install-dependencies)
  - [Build WineASIO Extension](#build-wineasio-extension)
  - [Configure Steam App Permissions](#configure-steam-app-permissions)
  - [Restart Steam App](#restart-steam-app)
- [How to Run](#how-to-run)
  - [Runtime Dependencies](#runtime-dependencies)
  - [Install Rocksmith 2014 \& Mods](#install-rocksmith-2014--mods)
  - [Configure Proton Version](#configure-proton-version)
  - [Adjust Launch Options](#adjust-launch-options)
  - [Run the Game from Steam](#run-the-game-from-steam)
- [How to Debug](#how-to-debug)


## Goals

- Run [Rocksmith 2014](https://store.steampowered.com/app/221680) with low latency audio.
  - [x] Support for user installed [rs_asio](https://github.com/mdias/rs_asio)
  - [x] Configure [wineasio](https://github.com/wineasio/wineasio) automatically

- Wide setup compatibility thanks to [PipeWire](https://pipewire.org/).
  - [x] Support for Rocksmith Real Tone Cable (RTC)
  - [x] Support for dedicated audio interfaces


## How to Build

This Flatpak is currently only built locally.

TL;DR: You can run all setup steps with default `make` target.

    make


### Install Dependencies

You need the following tools installed before proceeding.

    flatpak
    make


### Build WineASIO Extension

You can build locally with the following command.

    make build


### Configure Steam App Permissions

Adjust permissions for Steam Flatpak to allow usage of `pipewire-jack`.

    make overrides


### Restart Steam App

Finally, make sure to quit Steam if it is running, then start in development mode.

    make run

Steam can also be now started manually, without access to debugging tools.


## How to Run

Several steps need to be performed manually before running the game.


### Runtime Dependencies

Make sure your host operating system comes with `pipewire-jack`.

In case of Fedora Silverblue, run the following and reboot.

    rpm-ostree install pipewire-jack-audio-connection-kit.i686

Verify that `pipewire-jack` libraries are present.

    find /usr -name '*libjack.so.0*' 2>&-

    /usr/lib/pipewire-0.3/jack/libjack.so.0
    /usr/lib/pipewire-0.3/jack/libjack.so.0.3.1003
    /usr/lib64/pipewire-0.3/jack/libjack.so.0
    /usr/lib64/pipewire-0.3/jack/libjack.so.0.3.1003

See also:
  - https://wiki.archlinux.org/title/JACK_Audio_Connection_Kit
  - https://packages.fedoraproject.org/pkgs/pipewire/pipewire-jack-audio-connection-kit/


### Install Rocksmith 2014 & Mods

Install necessary mods in Rocksmith 2014 directory, incl. RS ASIO.

  - https://github.com/mdias/rs_asio/releases

Refer to Rocksmith 2014 On Linux guide for instructions.

  - https://github.com/theNizo/linux_rocksmith

This package automates `wineasio` build & setup steps for you.


### Configure Proton Version

Preferably, use an older Proton version like `7.0-6`, shipped by Steam.

- Alternatively, install a more recent version of Proton using
[ProtonUp-Qt](https://flathub.org/apps/net.davidotek.pupgui2).
- It is necessary to restart Steam to pick up available Proton versions.

Select Proton version in Rocksmith 2014 > Properties > Compatibility > Force Version.


### Adjust Launch Options

Modify launch options for Rocksmith 2014 to include `wineasioutil`.

Adjust `PIPEWIRE_LATENCY` to the correct value for your audio interface.

    PIPEWIRE_LATENCY="128/48000" /app/share/steam/compatibilitytools.d/WineASIO/bin/wineasioutil %command%

[`wineasioutil`](wineasioutil/) configures DLLs inside Proton installation & game prefix, and enables logging.


### Run the Game from Steam

At this point, run Rocksmith 2014 from Steam as usual.

You might need to do it twice in case of fresh install, or after deleting the game prefix.


## How to Debug

Refer to [Flatpak App Debugging guide](https://docs.flatpak.org/en/latest/debugging.html) for general overview.

Enable debug logging with `make`.

    make run DEBUG=9

Then, inspect logs in the following locations.

    $XDG_DATA_HOME/steam-221680.log
        Rocksmith 2014 launch logs.

    $XDG_DATA_HOME/wineasioutil.log
        WineASIO Util logs.

    $XDG_DATA_HOME/proton_$USER
        Proton debug scripts.

    $XDG_DATA_HOME/proton.log
        Proton launch logs.

Reveal filesystem locations of XDG directories as follows.

    flatpak run --command=env com.valvesoftware.Steam | grep XDG

Drop into Steam app shell.

    flatpak run --command=bash --devel com.valvesoftware.Steam
