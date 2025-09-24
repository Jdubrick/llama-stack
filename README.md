# Redhat-AI-Dev Llama Stack

## Image Availability

This image is built and available at [quay.io/redhat-ai-dev/llama-stack:latest](https://quay.io/repository/redhat-ai-dev/llama-stack) for both `amd64` and `arm64` architectures.

## Usage

> [!IMPORTANT]
> The default Llama Stack configuration file that is baked into the built image contains tools. Ensure your provided inference server has tool calling **enabled**.

There is a make target and 4 environment variables that you are able to set, broken up below into **required** and **optional**.

### Required
- `make get-rag`: Gets the RAG data and the embeddings model from the rag-content image registry to your local project dir
- `$VLLM_URL`: The url of your server, i.e. `http://localhost:8080/v1`
- `$VLLM_API_KEY`: API key for the `$VLLM_URL`
- `$PROVIDER`: The provider you want to use for question validation. This should match what the provider value you are using under `inference`, such as `vllm`, `ollama`, `openai`. Defaults to `vllm`
- `$MODEL_NAME`: The name of the LLM model you want to use for question validation

### Optional
- `$VLLM_MAX_TOKENS`: Defaults to `4096`
- `$VLLM_TLS_VERIFY`: Defaults to `true`
- `$LLAMA_STACK_LOGGING`: Set to `all=DEBUG` to enable `DEBUG` logging through Llama Stack

Run:
```
podman run -it -p 8321:8321 -e VLLM_URL=<your-url> -e VLLM_API_KEY=<api-key> -v ./embeddings_model:/app-root/embeddings_model -v ./vector_db/rhdh_product_docs:/app-root/vector_db/rhdh_product_docs quay.io/redhat-ai-dev/llama-stack:latest
```

**Note:** You can include all of these variables in a `.env` file and pass that instead to your container. See [default-values.env](./env/default-values.env) for a template. It is recommended you copy that file to `values.env` to avoid committing it to Git.

Run:
```
podman run -it -p 8321:8321 --env-file ./env/values.env -v ./embeddings_model:/app-root/embeddings_model -v ./vector_db/rhdh_product_docs:/app-root/vector_db/rhdh_product_docs quay.io/redhat-ai-dev/llama-stack:latest
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
