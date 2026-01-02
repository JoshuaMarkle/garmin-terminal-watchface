# This Makefile was designed for Arch Linux / terminal use
# It builds/simulates the watch face
# I reccomend using the vscode extention to test
# (it works the same)

SDK_DIR := $(HOME)/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.0-2025-12-03-5122605dc
JAR := $(SDK_DIR)/bin/monkeybrains.jar
CONNECTIQ := $(SDK_DIR)/bin/connectiq

APP := TerminalWatchFace
DEVICE := fr57047mm_sim

PRG := bin/$(APP).prg
JUNGLE := monkey.jungle
KEY := developer_key

.PHONY: all build sim clean

all: build sim

build:
	@echo "==> Building watch face"
	java -Xms1g -Dfile.encoding=UTF-8 -jar $(JAR) \
		-o $(PRG) \
		-f $(JUNGLE) \
		-y $(KEY) \
		-d $(DEVICE) \
		-w

SDK := $(HOME)/.Garmin/ConnectIQ/Sdks/connectiq-sdk-lin-8.4.0-2025-12-03-5122605dc
DEVICE := fr57047mm

sim:
	echo "==> Launching Garmin simulator"
	$(SDK)/bin/connectiq >/dev/null 2>&1 &
	sleep 5
	echo "==> Loading app onto $(DEVICE)"
	$(SDK)/bin/monkeydo bin/TerminalWatchFace.prg $(DEVICE)

clean:
	rm -f bin/*.prg
