FROM quay.io/centos-bootc/centos-bootc:stream10@sha256:a9f658042bec418c04d057942bd14af2d0f7da60ffd4a98018be17bec5c2d544

COPY files/ /

# Lock kernel versions
RUN dnf -y install 'dnf-command(versionlock)' && \
    dnf versionlock add $(rpm -qa --queryformat '%{NAME}-%{VERSION}-%{RELEASE}\n' kernel*)

# Manage packages
RUN dnf -y remove \
        subscription-manager \
    && \
    dnf -y install \
        qemu-guest-agent \
        cloud-init \
        nftables \
        epel-release \
    && \
    systemctl enable qemu-guest-agent.service && \
    systemctl enable cloud-init.service && \
    systemctl enable nftables.service \
    && \
    dnf clean all && \
    rm -rf /var/{cache,dnf,log}/*

COPY files/ /
