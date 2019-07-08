FROM debian:9.6-slim

LABEL "com.github.actions.name"="Auto-approve pull requests only once"
LABEL "com.github.actions.description"="Auto-approve pull requests only once"
LABEL "com.github.actions.icon"="thumbs-up"
LABEL "com.github.actions.color"="green"

LABEL version="1.0.0"
LABEL repository="http://github.com/afewyards/auto-approve-once-action"
LABEL homepage="http://github.com/afewyards/auto-approve-once-action"
LABEL maintainer="Thierry Kleist <thierry@kle.ist>"

RUN apt-get update && apt-get install -y \
    curl \
    jq

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
