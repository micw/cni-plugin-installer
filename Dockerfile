# In this container we test the install script

FROM busybox as test

ADD install_cni_plugins.sh /script/install_cni_plugins.sh
ADD test_install_cni_plugins.sh /script/test_install_cni_plugins.sh
WORKDIR /script
RUN /script/test_install_cni_plugins.sh


FROM golang:1.11 as build

ENV BRANCH_OR_TAG=v1.1.1

WORKDIR /go/src/app
RUN git clone --branch ${BRANCH_OR_TAG} \
      https://github.com/containernetworking/plugins.git . && \
    GO111MODULE=on ./build_linux.sh -ldflags="-extldflags=-static" -tags "osusergo netgo"

FROM busybox
COPY --from=build /go/src/app/bin /opt/cni/bin
VOLUME /host/opt/cni/bin
ADD install_cni_plugins.sh /script/install_cni_plugins.sh
CMD ["/script/install_cni_plugins.sh","/opt/cni/bin","/host/opt/cni/bin"]
