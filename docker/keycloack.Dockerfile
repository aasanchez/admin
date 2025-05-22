# Check current version of UBI https://catalog.redhat.com/software/containers/ubi9/618326f8c0d15aff4912fe0b
FROM registry.access.redhat.com/ubi9:9.6 AS ubi-micro-build
RUN mkdir -p /mnt/rootfs
# Search for current curl version https://catalog.redhat.com/software/containers/ubi9/ubi/615bcf606feffc5384e8452e?coentainer-tabs=packages
RUN dnf install --installroot /mnt/rootfs curl-7.76.1-31.el9 --releasever 9 --setopt install_weak_deps=false --nodocs -y && \
    dnf --installroot /mnt/rootfs clean all && \
    rpm --root /mnt/rootfs -e --nodeps setup

FROM quay.io/keycloak/keycloak:26.2.4
# Fix the path in the COPY command to match the actual root filesystem directory
COPY --from=ubi-micro-build /mnt/rootfs /mnt/rootfs
