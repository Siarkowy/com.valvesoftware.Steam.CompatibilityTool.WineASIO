SHELL := bash

BUILDER_APP := org.flatpak.Builder
STEAM_APP := com.valvesoftware.Steam
WINEASIO_APP := com.valvesoftware.Steam.CompatibilityTool.WineASIO

DEBUG := 9

.PHONY: all
all: test

.PHONY: build
build:
	flatpak install -y flathub $(BUILDER_APP)
	flatpak run $(BUILDER_APP) --user --install --force-clean build-dir $(WINEASIO_APP).yml

.PHONY: overrides
overrides:
	flatpak override --show --user $(STEAM_APP)

	# debugging level
	flatpak override --user --env=DEBUG=$(DEBUG) $(STEAM_APP)

	# pipewire socket access
	flatpak override --user --filesystem=xdg-run/pipewire-0 $(STEAM_APP)

	# realtime privileges (test me)
	flatpak override --user --system-talk-name=org.freedesktop.RealtimeKit1 $(STEAM_APP)
	flatpak override --user --own-name=org.freedesktop.ReserveDevice1.* $(STEAM_APP)

.PHONY: run
run:
	flatpak run --devel $(STEAM_APP)

.PHONY: test
test: build overrides run
