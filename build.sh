#! /bin/bash

set -e

# Allow overriding default docker command
DOCKER_CMD=${DOCKER_CMD:-docker}

# Allow disabling tests during build
RUN_TESTS=${RUN_TESTS:-1}

VERSION="$(git describe --dirty --always --tags | sed 's/-/./2' | sed 's/-/./2')"
BUILDDATE="$(date -u '+%Y-%m-%dT%H:%M:%S.%NZ')"

#-- Build final container
$DOCKER_CMD build \
        -t glusterfs-csi-driver \
        --build-arg RUN_TESTS="$RUN_TESTS" \
        --build-arg version="$VERSION" \
        --build-arg builddate="$BUILDDATE" \
        -f pkg/glusterfs/Dockerfile \
        . \
|| exit 1

if [ "$RUN_TESTS" -ne 0 ]; then
        rm -f profile.cov
        $DOCKER_CMD build \
                -t glusterfs-csi-driver-build \
                --target build \
                --build-arg RUN_TESTS="$RUN_TESTS" \
                -f pkg/glusterfs/Dockerfile \
                . \
        && \
        $DOCKER_CMD run --rm glusterfs-csi-driver-build \
                cat /profile.cov > profile.cov
fi
