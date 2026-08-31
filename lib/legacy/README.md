# Legacy / Migration Folder

This folder contains older screens and compatibility modules that were left during the project merge.

Rules:
- Do not add new code here.
- Prefer imports from `lib/app`, `lib/core`, `lib/data`, and `lib/features`.
- Only keep files here if they are still needed for migration or reference compatibility.
- Move anything here back to the active architecture when it is intentionally reused.
