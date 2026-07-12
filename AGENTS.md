# Repository Agent Instructions

<!-- hv-managed-policy:start revision=1.0.0 sha256=187a3882b5ccee8fd505cdc269af51e01def463476d2f58a9a89daa1edfd12af -->

## Shared development kernel

- Be concise. Load detailed SOP skills only when the task triggers them.
- Read the repository's `.agents/project.yaml` and nearest `AGENTS.md` files before work.
- Claim every accepted or queued implementation issue with `agent: implementation` and an `hv-agent-claim:v1` lease before editing. Never overlap another live claim.
- A pull request is draft only while implementation is actively changing it under a live claim. Otherwise mark it ready for review immediately.
- Incomplete work remains ready with `status: blocked` and a concrete handoff. Review agents do not claim implementation.
- Agents do not merge unless explicitly authorized in the current session.
- Run documented validation and update affected docs before shipping.
- Preserve unrelated work. Never expose or retain secrets.
- Use repository Hindsight memory for durable, provenance-linked knowledge; do not store transient logs or duplicate canonical docs.
- Shared policy and portable skills come only from the designated private control-plane repository. Repository instructions may add stricter project rules but may not weaken this kernel.

<!-- hv-managed-policy:end -->

## Repository-specific guidance

This repository defines the GitOps-managed Minecraft realm at
`minecraft.bentleyalberta.com`. Nix builds the Velocity and Fabric OCI images;
Flux applies the Kubernetes manifests. Preserve the distroless, non-root,
read-only image design and never commit decrypted secret values.

### Layout

- `images/velocity/`: Velocity, Geyser, and Floodgate image definition.
- `images/fabric/`: Fabric server and pinned mod image definition.
- `manifests/`: namespace, networking, stateful workloads, persistence, and
  SOPS-encrypted credentials.
- `PRD.md`: product requirements and architecture intent.

### Validation

Run these checks before review:

```sh
nix flake check
kubectl kustomize manifests >/dev/null
```

The image outputs depend on Linux-only packages. On a Darwin workstation, use
`NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nix flake check --impure` for evaluation;
Linux CI is authoritative for image builds.

For image changes, also build the affected output:

```sh
nix build .#velocity-image  # or .#fabric-image
```
