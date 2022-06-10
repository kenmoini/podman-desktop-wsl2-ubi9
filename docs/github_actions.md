# GitHub Actions

There is some sample configuration for using GitHub Actions to build and push the container image, then create a WSL2 Distro Import package.

The pipeline is a very simple CI job that basically just does a `docker build` and `docker push` and could be easily adapted to other CI platforms like Jenkins and Tekton.

## Prerequisites - Secrets

Create the following secrets:

- `REGISTRY_HOST` eg, `quay.io`
- `REGISTRY_REPO` eg, `kenmoini/podman-desktop-wsl2-ubi9`
- `REGISTRY_USERNAME` eg, `kenmoini`
- `REGISTRY_TOKEN` eg, `yourPasswordOrPersonalAccessToken`

The container will be built & pushed whenever there is new code pushed to the `main` branch.
