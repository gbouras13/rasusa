#!/usr/bin/env sh
set -ex

main() {
    if [ "$TRAVIS_OS_NAME" = linux ]; then
        target=x86_64-unknown-linux-musl
    else
        target=x86_64-apple-darwin
        alias sort='gsort'  # for `sort --sort-version`, from brew's coreutils.
    fi

    rustup component add rustfmt
    rustup component add clippy
    # This fetches latest stable release of cross
    tag=$(git ls-remote --tags --refs --exit-code https://github.com/japaric/cross \
                       | cut -d/ -f3 \
                       | grep -E '^v[0.1.0-9.]+$' \
                       | sort --version-sort \
                       | tail -n1)
    curl -LSfs https://japaric.github.io/trust/install.sh | \
        sh -s -- \
           --force \
           --git japaric/cross \
           --tag "$tag" \
           --target "$target"
}

main
