# Redhat-AI-Dev Llama Stack

- [Image Availability](#image-availability)
- [Usage](#usage)
  - [Available Inferences](#available-inferences)
    - [vLLM](#vllm)
    - [Ollama](#ollama)
    - [OpenAI](#openai)
  - [Configuring RAG](#configuring-rag)
  - [Configuring Question Validation](#configuring-question-validation)
  - [Running Locally](#running-locally)
  - [Running on a Cluster](#running-on-a-cluster)
- [Makefile Commands](#makefile-commands)
- [Contributing](#contributing)

## Image Availability

### Latest Stable Release

```
quay.io/redhat-ai-dev/llama-stack:0.1.0
```

### Latest Developer Release

```
quay.io/redhat-ai-dev/llama-stack:latest
```

## Usage

> [!IMPORTANT]
> The default Llama Stack configuration file that is baked into the built image contains tools. Ensure your provided inference server has tool calling **enabled**.

**Note:** You can enable `DEBUG` logging by setting:
```
LLAMA_STACK_LOGGING=all=DEBUG
```

### Available Inferences

Each inference has its own set of environment variables. You can include all of these variables in a `.env` file and pass that instead to your container. See [default-values.env](./env/default-values.env) for a template. It is recommended you copy that file to `values.env` to avoid committing it to Git.

> [!IMPORTANT]
> These are `.env` files, you should enter values without quotations to avoid errors in parsing. 
> 
> VLLM_API_KEY=token ✅
> 
> VLLM_API_KEY="token" ❌

#### vLLM

`vLLM` is the inference server enabled by default for this provided configuration of Llama Stack. In order to properly set it up you will need to set the following environment variables:

- `VLLM_URL`: The url of your server, i.e. `http://localhost:8080/v1`
- `VLLM_API_KEY`: API key for the `VLLM_URL`

In addition, you can set the following for more control over tokens and security:

- `VLLM_MAX_TOKENS`: Defaults to `4096`
- `VLLM_TLS_VERIFY`: Defaults to `true`

#### Ollama

If you want to use the llama-stack with a Ollama provider, for instance Ollama running on your laptop during development; uncomment the specific `remote::ollama` section in the `run.yaml` file and set the `OLLAMA_URL` environment variable.

The value of `OLLAMA_URL` is the default `http://localhost:11434`, when you are not running this llama-stack inside a container i.e.; if you run llama-stack directly on your laptop terminal, your llama-stack can reference and network with the Ollama at localhost.

The value of `OLLAMA_URL` is `http://host.containers.internal:11434` if you are running llama-stack inside a container i.e.; if you run llama-stack with the podman run command above, it needs to access the Ollama endpoint on your laptop not inside the container.

#### OpenAI

If you are having issues with llama-stack `remote::vllm` or `remote::ollama` with specific models, you can also use the `remote::openai` provider by uncommenting the specific section in the `run.yaml` file. Set the `OPENAI_API_KEY` environment variable. To get your API Key, go to [platform.openai.com](https://platform.openai.com/settings/organization/api-keys).

### Configuring RAG

The `run.yaml` file that is included in the container image has a RAG tool enabled. In order for this tool to have the necessary reference content, you need to run:

```
make get-rag
```

This will fetch the necessary reference content and add it to your local project directory.

### Configuring Question Validation

By default this Llama Stack has a Safety Shield for question validation enabled. You will need to set the following environment variables to ensure functionality:

- `VALIDATION_PROVIDER`: The provider you want to use for question validation. This should match what the provider value you are using under `inference`, such as `vllm`, `ollama`, `openai`. Defaults to `vllm`
- `VALIDATION_MODEL_NAME`: The name of the LLM you want to use for question validation

### Running Locally

```
podman run -it -p 8321:8321 --env-file ./env/values.env -v ./embeddings_model:/app-root/embeddings_model -v ./vector_db/rhdh_product_docs:/app-root/vector_db/rhdh_product_docs quay.io/redhat-ai-dev/llama-stack:latest
```

Latest Lightspeed Core developer image:
```
quay.io/lightspeed-core/lightspeed-stack:dev-latest
```

To run Lightspeed Core (Llama Stack should be running):
```
podman run -it -p 8080:8080 -v ./lightspeed-stack.yaml:/app-root/lightspeed-stack.yaml:Z quay.io/lightspeed-core/lightspeed-stack:dev-latest
```

**Note:** If you have built your own version of Lightspeed Core you can replace the image referenced with your own build. Additionally, you can use the Llama Stack container along with the `lightspeed-stack.yaml` file to run Lightspeed Core locally with `uv` from their [repository](https://github.com/lightspeed-core/lightspeed-stack).

### Running on a Cluster

To deploy on a cluster see [DEPLOYMENT.md](./docs/DEPLOYMENT.md).

# Makefile Commands

| Command | Description |
| ---- | ----|
| **get-rag** | Gets the RAG data and the embeddings model from the rag-content image registry to your local project directory |
| **update-question-validation** | Updates the question validation content in `providers.d` |

## Contributing

If you wish to try new changes with Llama Stack, you can build your own image using the `Containerfile` in the root of this repository.