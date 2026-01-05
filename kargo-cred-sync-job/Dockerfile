from alpline:3.18

RUN apk add --no-cache curl jq bash && \
    # Install kargo CLI
    curl -sSLf https://kargo.akuity.io/install.sh | bash

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh 