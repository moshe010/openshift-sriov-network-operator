FROM registry.svc.ci.openshift.org/openshift/release:golang-1.10 AS builder
WORKDIR /go/src/github.com/openshift/sriov-network-operator
COPY . .
RUN make build
RUN make plugins

FROM registry.svc.ci.openshift.org/openshift/origin-v4.0:base
COPY --from=builder /go/src/github.com/openshift/sriov-network-operator/build/_output/linux/amd64/manager /usr/bin/sriov-network-operator
COPY --from=builder /go/src/github.com/openshift/sriov-network-operator/build/_output/linux/amd64/sriov-network-config-daemon /usr/bin/
COPY --from=builder /go/src/github.com/openshift/sriov-network-operator/build/_output/linux/amd64/plugins /plugins
COPY bindata /bindata
ENV PLUGINSPATH=/plugins
ENV OPERATOR_NAME=sriov-network-operator
CMD ["/usr/bin/sriov-network-operator"]
