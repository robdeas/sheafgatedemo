// Copyright 2026 Rob Deas
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
// App-level configuration for SheafGate Launcher integration.
//
// DEV_AUTH_BYPASS:
//   false (default) — full launcher auth required. Use for all real builds.
//   true            — auth disabled for local development via `bun dev`.
//
// This file must exist. The build will fail without it, making it impossible
// to accidentally ship an app that hasn't explicitly configured auth.
export const DEV_AUTH_BYPASS = false;
