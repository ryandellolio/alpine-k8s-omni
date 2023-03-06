FROM alpine/k8s:1.23.17

ENV OMNI_ENDPOINT=
ENV OMNI_SERVICE_ACCOUNT_KEY=

# install perl-utils that includes shasum, which is required by the talos install
RUN apk add --update --no-cache perl-utils

# install curl
RUN apk add --update --no-cache curl

# install talos
RUN curl -sL https://talos.dev/install | sh

# copy omni binary, not packaged with this repository
COPY omnictl-linux-amd64 /usr/local/bin/omnictl

# make omni binary executable
RUN chmod u+x /usr/local/bin/omnictl

# copy entrypoint and ensure it's executable
COPY entrypoint.sh /usr/local/bin
RUN chmod u+x /usr/local/bin/entrypoint.sh

# start a shell when the container is run
CMD ["entrypoint.sh"]