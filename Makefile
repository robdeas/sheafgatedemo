# SheafLauncher Demo — top-level Makefile
#
# Generates a single UUID for each build, shared between the Go launcher
# and the Bun app. This UUID is baked into both binaries at compile time.
# A launcher will only authenticate the app it was built with.
#
# Usage:
#   make dev      — run Bun in dev mode (no launcher, no auth)
#   make build    — production build (runtime mode, Bun must be on PATH)
#   make compiled — production build (compiled mode, no Bun on target needed)
#   make clean    — remove build artifacts

ifeq ($(OS),Windows_NT)
    UUID := $(shell powershell -Command "[guid]::NewGuid().ToString()")
    EXE  := .exe
else
    UUID := $(shell uuidgen)
    EXE  :=
endif

.PHONY: build compiled dev clean

# Runtime mode — Bun must be installed on the target machine
build:
	@echo "==> Building sheafdemoengine (runtime mode)"
	@echo "==> UUID: $(UUID)"
	cd sheafdemoengine && PKM_LOGIN_UUID=$(UUID) bun run build
	@echo "==> Building sheaflauncher"
	cd sheaflauncher && go build \
		-ldflags "-X main.LoginUUID=$(UUID) -X main.BunMode=runtime" \
		-o ../sheafdemo$(EXE) \
		./cmd/launcher
	@echo "==> Done. Run ./sheafdemo$(EXE) to launch."

# Compiled mode — Bun compiles to a standalone binary, no Bun needed on target
compiled:
	@echo "==> Building sheafdemoengine (compiled mode)"
	@echo "==> UUID: $(UUID)"
	cd sheafdemoengine && PKM_LOGIN_UUID=$(UUID) bun build --compile --outfile ../app src/app.ts
	@echo "==> Building sheaflauncher"
	cd sheaflauncher && go build \
		-ldflags "-X main.LoginUUID=$(UUID) -X main.BunMode=compiled" \
		-o ../sheafdemo$(EXE) \
		./cmd/launcher
	@echo "==> Done. Run ./sheafdemo$(EXE) to launch."

# Dev mode — run Bun directly with fixed dev UUID, no auth required
dev:
	cd sheafdemoengine && PKM_LOGIN_UUID=dev-00000000-0000-0000-0000-000000000000 bun run dev

clean:
	rm -f sheafdemo sheafdemo.exe app app.exe
	rm -rf sheafdemoengine/build sheafdemoengine/.svelte-kit
