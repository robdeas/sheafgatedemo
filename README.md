# SheafGate Demo

A working demonstration of the **SheafGate Launcher** pattern — building desktop
apps with Go + Bun + SvelteKit, without Electron or Tauri.

## What Is SheafGate?

SheafGate is a pattern for turning any Bun/SvelteKit
web app into a desktop application. A thin Go binary acts as the launcher:
it spawns the Bun process, authenticates it, and opens the browser. From
the user's perspective it behaves like a native app — double-click and go.

The advantage over other ways of doing this such Electron or Tauri is that the application is full unmodified SvelteKit/ TypeScript and can use Bun shell etc.

## Repository Structure

```
sheafgatedemo/
  sheafgatelauncher/              ← Go launcher (~250 lines)
    cmd/launcher/
      main.go
    go.mod
  sheafgatedemoengine/            ← Bun/SvelteKit demo app
    src/
      lib/
        sheafgatelauncher/        ← auth library (copy into any app)
          auth.ts             ← session store, password handling
          hooks.ts            ← SvelteKit handle factory + ready signal
          launcherControl.ts  ← login / heartbeat / shutdown handlers
        config.ts             ← DEV_AUTH_BYPASS flag
      routes/
        sheafgatelauncher-control/
          +server.ts          ← thin re-export from library
        login/
          +page.svelte        ← fallback "use the launcher" page
        +page.svelte          ← demo page showing connection status
      hooks.server.ts         ← thin re-export from library
    vite.config.ts
    svelte.config.js
    package.json
  Makefile                    ← top-level build, generates shared UUID
  LICENSE                     ← Apache-2.0
```

## How the Auth Works

Both binaries are built with a shared UUID generated at compile time:

```
Makefile generates UUID
  ├─ Go launcher: go build -ldflags "-X main.LoginUUID=<uuid>"
  └─ Bun app:     PKM_LOGIN_UUID=<uuid> bun run build
```

At runtime:

```
1. Go generates a one-time random password (crypto/rand)
2. Go picks a free port in 47000-48000
3. Go spawns Bun with PKM_PASSWORD=<password> --port <port>
4. Bun reads password from env, outputs {"status":"ready"}
5. Go opens browser: /launcher-control?uuid=<uuid>&password=<password>
6. Bun checks: UUID matches build? Password matches env? → set session cookie
7. Browser redirects to / with session cookie — user is in
8. Go heartbeats every 5s via POST /launcher-control?uuid=<uuid>
9. On exit: Go sends DELETE /launcher-control?uuid=<uuid> → clean shutdown
```

A launcher only works with the app it was built with. If another process
is on the same port, the UUID won't match and login fails immediately.

## Getting Started

### Prerequisites

- [Bun](https://bun.sh) >= 1.0
- [Go](https://go.dev) >= 1.22

### Development (no launcher, no auth)

```bash
cd sheafgatedemoengine
bun install
cd ..
make dev
# Opens http://localhost:5173 in your browser
# Full browser devtools, no launcher involved
```

To develop with auth enabled, set `DEV_AUTH_BYPASS = false` in
`sheafgatedemoengine/src/lib/config.ts` and use the launcher instead.

### Production Build

```bash
cd sheafgatedemoengine && bun install && cd ..
make build
```

This produces:
- `sheafdemo` (or `sheafdemo.exe` on Windows) — the Go launcher
- `sheafgatedemoengine/build/` — the Bun app (copy alongside the launcher)

Run `./sheafgatedemo` — browser opens automatically, app is ready.

## Using SheafGate Launcher in Your Own App

The launcher is ~250 lines of Go. To use it for a new app:

1. Copy `sheafgatelauncher/` into your project
2. Update the module name in `sheaflauncher/go.mod`
3. Update the output binary name in your `Makefile`
4. Copy `sheafgatedemoengine/src/lib/sheafgatelauncher/` into your SvelteKit app
5. Add the three thin wiring files (hooks.server.ts, +server.ts, config.ts)
6. Add the `__PKM_LOGIN_UUID__` define to your `vite.config.ts`
7. Run `make build`

That's it. Write your SvelteKit app normally. The launcher handles the rest.

## Why Not Electron / Tauri / Wails?

| | SheafLauncher | Electron | Tauri | Wails |
|---|---|---|---|---|
| Binary size | ~25MB | ~150MB | ~10MB | ~15MB |
| Extra language | — | — | Rust | Go |
| Cold start | ~2s | ~4s | ~1s | ~2s |
| Web devtools | ✓ native | ✓ | partial | partial |
| App stores | ✗ | ✓ | ✓ | ✗ |
| Use system browser | ✓ | ✗ | ✗ | ✗ |

SheafGate Launcher is the right choice when you want to write pure SvelteKit
without learning a native bridge API, and you're targeting desktop machines
you control (not app stores).

## License

Apache-2.0 — see [LICENSE](LICENSE)

Copyright 2026 Rob Deas
