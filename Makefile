ONESHELL:

MAKEFLAGS += --silent

EMULATOR_NAME := vama_emulator

emulator-create:
	echo "Creating a default AVD..."
	${androidSdk}/bin/avdmanager create avd -n ${EMULATOR_NAME} -k "system-images;android-34;google_apis_playstore;x86_64" -d "pixel_5"
emulator-run:
	echo "Starting the Android emulator..."
	${androidSdk}/bin/emulator -avd ${EMULATOR_NAME} -no-snapshot -gpu host > /dev/null 2>&1 &
	disown

.PHONY: emulator-create emulator-run
