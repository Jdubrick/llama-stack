# Redhat-AI-Dev Llama Stack

[![Apache2.0 License](https://img.shields.io/badge/license-Apache2.0-brightgreen.svg)](LICENSE)

- [Version Table](#version-table)
- [Provider Configuration](#provider-configuration)
- [Running Locally](#running-locally)
- [Configuring RAG Content](#configuring-rag-content)
- [Configuring Safety Guards](#configuring-safety-guards)
- [Running on a Cluster](#running-on-a-cluster)
- [Makefile Commands](#makefile-commands)
- [Updating/Formatting YAML Files](#updatingformatting-yaml-files)
- [Adding a New Llama Stack Version](#adding-a-new-llama-stack-version)
- [Troubleshooting](#troubleshooting)

## Version Table

| Llama Stack Version | Llama Stack Image | Lightspeed Core Image | RAG Image |
| ---- | ---- | ---- | ---- |
| `0.4.3` | `registry.redhat.io/rhoai/odh-llama-stack-core-rhel9:v3.3` | `quay.io/lightspeed-core/lightspeed-stack:dev-20260226-ca21850` | `quay.io/redhat-ai-dev/rag-content:release-1.9-lls-0.4.3` |
| `0.3.5` | `quay.io/redhat-ai-dev/llama-stack:0.1.4` | `quay.io/lightspeed-core/lightspeed-stack:0.4.0` | `quay.io/redhat-ai-dev/rag-content:release-1.9-lcs` |
| `0.2.18` | `quay.io/redhat-ai-dev/llama-stack:0.1.2` | `quay.io/lightspeed-core/lightspeed-stack:dev-20251021-ee9f08f` | `quay.io/redhat-ai-dev/rag-content:release-1.8-lcs` |

## Provider Configuration

Provider-specific setup and environment variable details live in [PROVIDERS.md](./docs/PROVIDERS.md).

## Running Locally

Run `make get-rag` first so `./rag-content` exists locally.
Also ensure `./env/values.env` exists (copy from `./env/default-values.env`).

Start the local API stack for `0.4.3`:

```sh
make local-up
```

Disable Ollama and use `run-no-guard.yaml` instead:

```sh
make local-up WITH_OLLAMA=false
```

Stop services:

```sh
make local-down
```

By default (`WITH_OLLAMA=true`), `make local-up` uses:

- `llama-stack-configs/0.4.3/run.yaml`
- an Ollama container in compose (required for serving the safety model)
- compose enforces startup order: Ollama serving with safety model available -> Llama Stack/Lightspeed start
- Ollama/Safety env vars from `env/values.env`

With `WITH_OLLAMA=false`, `make local-up` applies `compose/compose.no-ollama.yaml` and uses:

- `llama-stack-configs/0.4.3/run-no-guard.yaml`
- no Ollama container (safety guards disabled)

## Configuring RAG Content

Pull the embeddings model and vector database locally:

```sh
make get-rag
```

This command fully replaces `./rag-content` on each run.

By default, `get-rag` uses the `0.4.3` RAG image.

You can also provide a full image reference directly:

```sh
make get-rag RAG_CONTENT_IMAGE=quay.io/redhat-ai-dev/rag-content:<tag>
```

## Configuring Safety Guards

In `llama-stack-configs/<version>/run.yaml`, Llama Guard is enabled by default.

> [!IMPORTANT]
> To skip safety guards for development, use `run-no-guard.yaml` where available under `llama-stack-configs/<version>/`.

Start an Ollama container and pull Llama Guard:

```sh
podman run -d --name ollama -p 11434:11434 docker.io/ollama/ollama:latest
podman exec ollama ollama pull llama-guard3:8b
```

Set these environment variables as needed:

- `SAFETY_MODEL`: Llama Guard model name. Defaults to `llama-guard3:8b`
- `SAFETY_URL`: Endpoint URL. Defaults to `http://host.docker.internal:11434/v1`
- `SAFETY_API_KEY`: API key, not required for local

## Makefile Commands

| Command | Description |
| ---- | ---- |
| `get-rag` | Pull and unpack RAG content into `./rag-content` (replaces existing contents). Optional: `RAG_CONTENT_IMAGE=<image>`. |
| `local-up` | Start local compose services for `0.4.3`. Default: `WITH_OLLAMA=true` (uses `run.yaml`). Set `WITH_OLLAMA=false` to use `run-no-guard.yaml`. |
| `local-down` | Stop local compose services. |
| `validate-yaml` | Validate YAML formatting/syntax in config directories. |
| `format-yaml` | Format YAML files in config directories. |
| `update-question-validation` | Update question-validation content in `config/providers.d`. |
| `validate-prompt-templates` | Validate prompt values against upstream templates. |
| `update-prompt-templates` | Update prompt values from upstream templates. |

## Updating/Formatting YAML Files

Use make targets (these are also used by CI for validation):

```sh
make format-yaml
make validate-yaml
```

## Adding a New Llama Stack Version

When introducing a new supported version:

1. Create a new directory in `llama-stack-configs` named exactly as the version (for example `llama-stack-configs/0.5.0`).
2. Add required configuration files (`run.yaml`, and `run-no-guard.yaml` if applicable).
3. Reuse the previous version's files as a baseline, then update version-specific model/provider details.
4. Run formatting and validation:

```sh
make format-yaml
make validate-yaml
```

1. Update the [Version Table](#version-table) in this README with image references.

## Troubleshooting

Enable debug logs:

```sh
LLAMA_STACK_LOGGING=all=DEBUG
```

If you hit a permission error for `vector_db`, such as:

```sh
sqlite3.OperationalError: attempt to write a readonly database
```

fix permissions with:

```sh
chmod -R 777 rag-content/vector_db
```