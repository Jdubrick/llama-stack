# Redhat-Ai-Dev Llama Stack

## Image Availability

This image is built and available at quay.io/rh-ee-jdubrick/llama-stack:latest for both `amd64` and `arm64` architectures.

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
podman run -it -p 8321:8321 -e VLLM_URL=<your-url> -e VLLM_API_KEY=<api-key> quay.io/rh-ee-jdubrick/llama-stack:latest
```