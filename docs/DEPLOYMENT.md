# Deployment

Below you can find documentation related to deploying `Lightspeed Core` and `Llama Stack` in a Pod with `Red Hat Developer Hub (RHDH)`.

## Prerequisites

- Red Hat Developer Hub

## Adding Containers

We need to add `Lightspeed Core` and `Llama Stack` to our `RHDH` Pod by adding the following to the `Backstage` CR:

```yaml
spec:
  deployment:
    patch:
      spec:
        template:
          spec:
            containers:
              - env:
                  - name: VLLM_URL
                    value: <your-url>
                  - name: VLLM_API_KEY
                    value: <your-key>
                image: 'quay.io/redhat-ai-dev/llama-stack:latest'
                name: llama-stack
                volumeMounts:
                  - mountPath: /app-root/.llama
                    name: llama-storage
              - image: 'quay.io/lightspeed-core/lightspeed-stack:dev-latest'
                name: lightspeed-core
                volumeMounts:
                  - mountPath: /app-root/lightspeed-stack.yaml
                    name: lightspeed-stack
                    subPath: lightspeed-stack.yaml
            volumes:
              - configMap:
                  name: lightspeed-stack
                name: lightspeed-stack
              - emptyDir: {}
                name: llama-storage
```

Also ensure that `lightspeed-stack` is created as a `Config Map` in the namespace:

```yaml
name: Lightspeed Core Service (LCS)
service:
  host: 0.0.0.0
  port: 8080
  auth_enabled: false
  workers: 1
  color_log: true
  access_log: true
llama_stack:
  use_as_library_client: false
  url: http://localhost:8321
user_data_collection:
  feedback_enabled: false
  feedback_storage: "/tmp/data/feedback"
  transcripts_enabled: false
  transcripts_storage: "/tmp/data/transcripts"
  data_collector:
    enabled: false
    ingress_server_url: null
    ingress_server_auth_token: null
    ingress_content_service_name: null
    collection_interval: 7200
    cleanup_after_send: true
    connection_timeout_seconds: 30
authentication:
  module: "noop"
```

## Troubleshooting

In the current state you need to add the following to your `RHDH` configuration file to enable Lightspeed:

```yaml
lightspeed:
  servers:
    - id: <your-id>
      url: <your-url>
      token: <your-token>
```

> [!IMPORTANT]
> Since we need to add inference servers in `Llama Stack` as well as `Lightspeed` (temporarily?), you must ensure that the `id` of your `Lightspeed` server is `vllm`.