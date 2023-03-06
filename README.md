# alpine-k8s-omni docker image
Toolbox for k8s in the Sidero ecosystem that adds `talosctl` and `omnictl` to the [alpine/k8s](https://hub.docker.com/r/alpine/k8s/tags/) image of existing tools such as `kubectl`, `helm` and others.

The image allows optional authentication environment variables to allow `omnictl` to automatically authenticate, and provides a slim version with only `talosctl` and `omnictl`.

[view on dockerhub](https://hub.docker.com/r/ryandellolio/alpine-k8s-omni)

## prerequisites
1. Before building, you must include the `omnictl-<env>-<arch>` binary from your Omni dashboard in the root of your repository, and optionally update the `COPY` command in the Dockerfile if you are using a different architecture
2. If using optional authentication, you must create an omni service account and pass the given environment variables to retrieve the token

## testing
1. For testing purposes, you can put a test token in `.env` using `omnictl serviceaccount create spot-operator > .env` and remove excess text.  Store securely.
2. Build with `docker build --no-cache -t alpine-k8s-omni .`
3. Run with `docker run -it --rm --env-file ./.env alpine-k8s-omni /bin/sh` to try it out.

## pushing to docker registry with multiple architectures using buildx
Use buildx to build and push to the docker registry by running the following build commands:

### latest
```
docker buildx build --push \
--platform linux/amd64,linux/arm64 \
--tag ryandellolio/alpine-k8s-omni:latest .
```

### slim
```
docker buildx build -f Dockerfile-slim --push \
--platform linux/amd64,linux/arm64 \
--tag ryandellolio/alpine-k8s-omni:slim .
```

### semver
```
docker buildx build -f Dockerfile-slim --push \
--platform linux/amd64,linux/arm64 \
--tag ryandellolio/alpine-k8s-omni:0.1.1 .
```

### semver slim
```
docker buildx build -f Dockerfile-slim --push \
--platform linux/amd64,linux/arm64 \
--tag ryandellolio/alpine-k8s-omni:0.1.1-slim .
```

## `omnictl` authentication
If you set `OMNI_ENDPOINT` and `OMNI_SERVICE_ACCOUNT_KEY` environment variables, `omnictl` will automatically authenticate in the container and can be used in the container automatically for cluster operations.

Retreive your token using an already authenticated machine by running `omnictl serviceaccount create <user>` to create a service account for this purpose.

## slim version
If you don't need all of the bells and whistles of alpine/k8s and just need `omnictl` and `talosctl`, build the slim version instead with `docker build --no-cache -f Dockerfile-slim -t alpine-k8s-omni:slim .`

## use without building
Images are posted on [dockerhub](https://hub.docker.com/r/ryandellolio/alpine-k8s-omni) at and can be tried using:
- full version `docker run -it ryandellolio/alpine-k8s-omni /bin/sh`
- slim version `docker run -it ryandellolio/alpine-k8s-omni:slim /bin/sh`

## to do
1. Automatically authenticate `talosctl`, pending feasibility analysis
2. Automate multiple builds for different architectures, optionally pending public distribution of `omnictl`
