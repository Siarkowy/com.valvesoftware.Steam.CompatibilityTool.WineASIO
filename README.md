# Steam WineASIO Flatpak <!-- omit in toc -->

WineASIO extension for Steam Flatpak, built as a patch on top of
[org.winehq.Wine](https://github.com/flathub/org.winehq.Wine) Flatpak.

This is an early stage proof of concept.


## Contents <!-- omit in toc -->

<!-- vscode: ext install yzhang.markdown-all-in-one -->
- [Goal](#goal)
- [Dependencies](#dependencies)
- [How to Build](#how-to-build)
  - [Build WineASIO Extension](#build-wineasio-extension)
  - [Configure Steam App Permissions](#configure-steam-app-permissions)
  - [Run Steam App](#run-steam-app)
- [How to Run](#how-to-run)
  - [Install Rocksmith 2014 \& Mods](#install-rocksmith-2014--mods)
  - [Configure Proton](#configure-proton)
  - [Adjust Launch Options](#adjust-launch-options)
- [Debugging](#debugging)


## Goal

Run [Rocksmith 2014](https://www.protondb.com/app/221680) with low-latency `pipewire-jack`.

Rocksmith Cable setup is not supported.


## Dependencies

    flatpak
    make


## How to Build

This Flatpak is currently only built locally.

TL;DR: You can run all setup steps with default `make` target.

    make


### Build WineASIO Extension

You can build locally with the following command.

    make build


### Configure Steam App Permissions

Adjust permissions for Steam Flatpak to allow usage of `pipewire-jack`.

    make overrides


### Run Steam App

Finally, make sure to quit Steam if it is running, then start in development mode.

    make run

Steam can also be now started manually, without access to SDK tools.

See https://docs.flatpak.org/en/latest/debugging.html for more details.


## How to Run

Several steps need to be performed manually before running the game.


### Install Rocksmith 2014 & Mods

Install all necessary mods in Rocksmith 2014 directory, incl. RS ASIO.

  - https://github.com/mdias/rs_asio/releases

Refer to Linux Rocksmith Guide for instructions.

  - https://github.com/theNizo/linux_rocksmith


### Configure Proton

Preferably, install a dedicated, current version of Proton using
[ProtonUp-Qt](https://flathub.org/apps/net.davidotek.pupgui2).

It is necessary to restart Steam to pick up available Proton versions.

Select Proton version in Rocksmith 2014 > Properties > Compatibility >
Force Version.


### Adjust Launch Options

Modify launch options for Rocksmith 2014 to include `wineasioutil`.

Adjust `PIPEWIRE_LATENCY` to the correct value for your audio interface.

    PIPEWIRE_LATENCY="256/48000" /app/share/steam/compatibilitytools.d/WineASIO/bin/wineasioutil %command%

[`wineasioutil`](wineasioutil/) configures DLLs inside Proton installation & game prefix, and enables logging.


## Debugging

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
