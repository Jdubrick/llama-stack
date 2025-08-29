# Redhat-Ai-Dev Llama Stack

## Image Availability

This image is built and available at [quay.io/redhat-ai-dev/llama-stack:latest](https://quay.io/repository/redhat-ai-dev/llama-stack) for both `amd64` and `arm64` architectures.

## Usage

There are 4 environment variables that you are able to set, broken up below into **required** and **optional**.

### Required
- `$VLLM_URL`: The url of your server, i.e. `http://localhost:8080/v1`
- `VLLM_API_KEY`: API key for the `$VLLM_URL`

### Optional
- `$VLLM_MAX_TOKENS`: Defaults to `4096`
- `$VLLM_TLS_VERIFY`: Defaults to `true`

Run:
```
podman run -it -p 8321:8321 -e VLLM_URL=<your-url> -e VLLM_API_KEY=<api-key> quay.io/redhat-ai-dev/llama-stack:latest
```

#### Using the Ollama provider

If you want to use the llama-stack with a Ollama provider, for instance Ollama running on your laptop during development; uncomment the specific `remote::ollama` section in the `run.yaml` file and set the `OLLAMA_URL` environment variable.

The value of `OLLAMA_URL` is the default `http://localhost:11434`, when you are not running this llama-stack inside a container i.e.; if you run llama-stack directly on your laptop terminal, your llama-stack can reference and network with the Ollama at localhost.

The value of `OLLAMA_URL` is `http://host.containers.internal:11434` if you are running llama-stack inside a container i.e.; if you run llama-stack with the podman run command above, it needs to access the Ollama endpoint on your laptop not inside the container.

#### Using the OpenAI provider

If you are having issues with llama-stack `remote::vllm` or `remote::ollama` with specific models, you can also use the `remote::openai` provider by uncommenting the specific section in the `run.yaml` file. Set the `OPENAI_API_KEY` environment variable. To get your API Key, go to [platform.openai.com](https://platform.openai.com/settings/organization/api-keys).

## Updating Llama Stack

If you wish to try new changes with Llama Stack, you can build your own image using the `Containerfile` in the root of this repository.

## Using With Lightspeed Core

Latest Lightspeed Core developer image:
```
quay.io/lightspeed-core/lightspeed-stack:dev-latest
```

To run Lightspeed Core (Llama Stack should be running):
```
podman run -it -p 8080:8080 -v ./lightspeed-stack.yaml:/app-root/lightspeed-stack.yaml:Z quay.io/lightspeed-core/lightspeed-stack:dev-latest
```

**Note:** If you have built your own version of Lightspeed Core you can replace the image referenced with your own build. Additionally, you can use the Llama Stack container along with the `lightspeed-stack.yaml` file to run Lightspeed Core locally with `uv` from their [repository](https://github.com/lightspeed-core/lightspeed-stack).

## Cluster Deployment

To deploy on a cluster see [DEPLOYMENT.md](./docs/DEPLOYMENT.md).