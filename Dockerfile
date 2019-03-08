FROM golang:1.11 as build

WORKDIR /go/src/app
RUN git clone https://github.com/containernetworking/plugins.git . && \
    ./build_linux.sh

FROM busybox
COPY --from=build /go/src/app/bin /opt/cni/bin
VOLUME /host/opt/cni/bin
WORKDIR /opt/cni/bin
