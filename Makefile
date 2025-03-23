ONESHELL:

MAKEFLAGS += --silent

EMULATOR_NAME := vama_emulator

emulator-create:
	avdmanager create avd -n ${EMULATOR_NAME} -k "system-images;android-34;google_apis_playstore;x86_64" -d "pixel_5"
emulator-run:
	emulator -avd ${EMULATOR_NAME} -no-snapshot -gpu host

.PHONY: emulator-create emulator-run
