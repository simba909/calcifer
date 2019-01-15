setup:
	git submodule init
	carthage bootstrap --platform macOS --cache-builds
