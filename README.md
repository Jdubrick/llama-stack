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

## Updating Llama Stack

If you wish to try new changes with Llama Stack, you can build your own image using the `Containerfile` in the root of this repository.

## Using With Lightspeed Core

Latest Lightspeed Core developer image:
```
quay.io/lightspeed-core/lightspeed-stack:dev-latest
```

To run Lightspeed Core (Llama Stack should be running):
```
podman run -it -p 8080:8080 -v lightspeed-stack.yaml:/app-root/lightspeed-stack.yaml:Z quay.io/lightspeed-core/lightspeed-stack:dev-latest
```

**Note:** If you have built your own version of Lightspeed Core you can replace the image referenced with your own build. Additionally, you can use the Llama Stack container along with the `lightspeed-stack.yaml` file to run Lightspeed Core locally with `uv` from their [repository](https://github.com/lightspeed-core/lightspeed-stack).