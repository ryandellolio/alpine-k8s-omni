# alpine-k8s-omni docker image
Toolbox for k8s in the Sidero ecosystem that adds `talosctl` and `omnictl` to the [alpine/k8s](https://hub.docker.com/r/alpine/k8s/tags/) image of existing tools such as `kubectl`, `helm` and others.

The image allows optional authentication environment variables to allow `omnictl` to automatically authenticate, and has a slim variant with only `talosctl` and `omnictl`.

## use it

### publicly hosted image

[view on dockerhub](https://hub.docker.com/r/ryandellolio/alpine-k8s-omni)

Images are posted on [dockerhub](https://hub.docker.com/r/ryandellolio/alpine-k8s-omni) and can be tried using:
- full version `docker run -it ryandellolio/alpine-k8s-omni /bin/sh`
- slim version `docker run -it ryandellolio/alpine-k8s-omni:slim /bin/sh`

## building the image

### prerequisites
1. Before building, you must include the `omnictl-<env>-<arch>` binary from your Omni dashboard in the root of your repository, and optionally update the `COPY` command in the Dockerfile if you are using a different architecture
2. If using optional authentication, you must create an omni service account and pass the given environment variables to retrieve the token.  See below.

### testing

#### without authentication
1. Build with `docker build --no-cache -t alpine-k8s-omni .`
2. Run with `docker run -it --rm alpine-k8s-omni /bin/sh`

#### with authentication
If you set `OMNI_ENDPOINT` and `OMNI_SERVICE_ACCOUNT_KEY` environment variables, `omnictl` will automatically authenticate in the container and can be used immediately for cluster operations.

1. For testing purposes, you can put the required environment variables in `.env` using `omnictl serviceaccount create spot-operator > .env` and remove excess text.  Store securely.
2. Build with `docker build --no-cache -t alpine-k8s-omni .`
3. Run with `docker run -it --rm --env-file ./.env alpine-k8s-omni /bin/sh` to try it out.

### pushing to docker registry

Use buildx to build and push to docker hub.

#### relevant commands
The following build commands allow locally pushing to dockerhub on multiple architectures using `buildx`

##### full latest
```
docker buildx build --push \
--platform linux/amd64,linux/arm64 \
--tag ryandellolio/alpine-k8s-omni:latest .
```

##### slim latest
```
docker buildx build -f Dockerfile-slim --push \
--platform linux/amd64,linux/arm64 \
--tag ryandellolio/alpine-k8s-omni:slim .
```

##### full semver
```
docker buildx build -f Dockerfile-slim --push \
--platform linux/amd64,linux/arm64 \
--tag ryandellolio/alpine-k8s-omni:0.1.1 .
```

##### slim semver
```
docker buildx build -f Dockerfile-slim --push \
--platform linux/amd64,linux/arm64 \
--tag ryandellolio/alpine-k8s-omni:0.1.1-slim .
```

## slim version
If you don't need all of the bells and whistles of alpine/k8s and just need `omnictl` and `talosctl`, you can use the slim version of this image whose base is `alpine:latest`

## to do
1. Automatically authenticate `talosctl`, pending feasibility analysis
2. Automate the build process
