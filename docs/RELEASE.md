# Release
---
## Checklist

1. Create new branch `release-vX.X.X` that will house the contents of the release.
   - E.g. For release `0.1.0` you would create `release-v0.1.x`.
   - A new release branch should be created for each `Major` and `Minor` release, `Patch` releases will go into their respective `Major.Minor` branch.
2. Update the version in [pyproject.toml](../pyproject.toml).
3. Update the `Latest Stable Release` section in [README.md](../README.md).
4. Create new release Tag on GitHub.
   - GitHub Action CI will build and push the release image `X.X.X`.
   - E.g. For release `0.1.0` it will build and push `quay.io/redhat-ai-dev/llama-stack:0.1.0`.
5. Announce release on Slack in `#forum-rhdh-plugins-and-ai`.