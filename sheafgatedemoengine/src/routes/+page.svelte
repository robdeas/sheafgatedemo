<!-- Copyright 2026 Rob Deas -->
<!-- SPDX-License-Identifier: Apache-2.0 -->
<script lang="ts">
  import { onMount, onDestroy } from 'svelte';

  let uptime = 0;
  let interval: ReturnType<typeof setInterval>;

  onMount(() => {
    interval = setInterval(() => { uptime++; }, 1000);
  });

  onDestroy(() => clearInterval(interval));

  function formatUptime(s: number): string {
    if (s < 60) return `${s}s`;
    if (s < 3600) return `${Math.floor(s / 60)}m ${s % 60}s`;
    return `${Math.floor(s / 3600)}h ${Math.floor((s % 3600) / 60)}m`;
  }
</script>

<svelte:head>
  <title>SheafDemo</title>
</svelte:head>

<main>
  <div class="card">
    <div class="icon">◈</div>
    <h1>SheafDemo</h1>
    <p class="subtitle">SvelteKit + Bun running via SheafGate Launcher</p>

    <div class="status">
      <div class="row">
        <span class="label">Uptime</span>
        <span class="value">{formatUptime(uptime)}</span>
      </div>
      <div class="row">
        <span class="label">Auth</span>
        <span class="value ok">● Session active</span>
      </div>
    </div>

    <p class="note">
      This page is served by a Bun/SvelteKit process spawned by the Go launcher.
      Authentication used a build-time UUID and a one-time runtime password.
      No Electron. No Tauri. Just Standard SvelteKit and TypeScript on Bun.
    </p>

    <div class="links">
      <a href="https://github.com/robdeas/sheafgatedemo" target="_blank">
        View source on GitHub
      </a>
    </div>
  </div>
</main>

<style>
  :global(*, *::before, *::after) { box-sizing: border-box; }
  :global(body) {
    margin: 0;
    background: #0a0a0a;
    color: #e0e0e0;
    font-family: 'Inter', system-ui, sans-serif;
  }

  main {
    display: flex;
    align-items: center;
    justify-content: center;
    min-height: 100vh;
    padding: 2rem;
  }

  .card {
    background: #111;
    border: 1px solid #1e1e1e;
    border-radius: 1rem;
    padding: 3rem;
    max-width: 500px;
    width: 100%;
    text-align: center;
  }

  .icon {
    font-size: 3rem;
    color: #4ade80;
    margin-bottom: 1rem;
  }

  h1 {
    font-size: 1.75rem;
    font-weight: 300;
    margin: 0 0 0.375rem;
    color: #f0f0f0;
    letter-spacing: -0.02em;
  }

  .subtitle {
    color: #555;
    font-size: 0.8125rem;
    margin: 0 0 2rem;
  }

  .status {
    background: #0d0d0d;
    border: 1px solid #1a1a1a;
    border-radius: 0.5rem;
    padding: 0.25rem 1.5rem;
    margin-bottom: 2rem;
    text-align: left;
  }

  .row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0.5rem 0;
    border-bottom: 1px solid #161616;
    font-size: 0.8125rem;
    font-family: monospace;
  }

  .row:last-child { border-bottom: none; }

  .label { color: #444; }
  .value { color: #bbb; }
  .value.ok { color: #4ade80; }

  .note {
    font-size: 0.75rem;
    color: #3a3a3a;
    line-height: 1.7;
    margin: 0 0 1.5rem;
  }

  .links a {
    font-size: 0.75rem;
    color: #4ade80;
    text-decoration: none;
    font-family: monospace;
  }

  .links a:hover { text-decoration: underline; }
</style>