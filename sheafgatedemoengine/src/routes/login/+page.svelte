<!-- Copyright 2026 Robokeys Ltd -->
<!-- SPDX-License-Identifier: Apache-2.0 -->
<!--
  Fallback login page — shown if the user navigates to /login directly
  without going through the launcher. Intentionally shows nothing useful.
  There is no login form here — authentication only happens via the launcher.
-->
<script>
  import ManualLoginPage from '$lib/sheafgate/ManualLoginPage.svelte';
</script>

<ManualLoginPage />