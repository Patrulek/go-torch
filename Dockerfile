FROM golang:1.9-alpine

ENV PATH $PATH:/opt/flamegraph
ENV FLAMEGRAPH_SHA a93d905911c07c96a73b35ddbcb5ddb2f39da4b6

RUN apk --update add git && \
  apk add curl && \
  curl -OL https://github.com/Masterminds/glide/releases/download/v0.12.3/glide-v0.12.3-linux-amd64.tar.gz && \
  tar -xzf glide-v0.12.3-linux-amd64.tar.gz && \
  mv linux-amd64/glide /usr/bin && \
  apk add perl && \
  git clone git://github.com/brendangregg/FlameGraph.git /opt/flamegraph && \
  ( cd /opt/flamegraph && \
  git reset --hard $FLAMEGRAPH_SHA && \
  rm -rf .git )

COPY . /go/src/github.com/patrulek/go-torch

RUN cd /go/src/github.com/patrulek/go-torch && glide install && go install ./...

ENTRYPOINT ["go-torch"]
