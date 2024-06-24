#! /usr/bin/env bash

PKGBUILD=$(curl 'https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=f1multiviewer-bin')

# Extract version
version=$(echo "${PKGBUILD}" | grep "pkgver=" - | awk -F '=' '{ print $2 }' -)
# Extract build id
id=$(echo "${PKGBUILD}" | grep "_build=" - | awk -F '=' '{ print $2 }' -)
# Extract and convert the hash
hash=$(echo "${PKGBUILD}" | grep "sha256sums=" - | awk -F "'" '{ print $2 }')
hash=$( nix-hash --type sha256 --to-sri ${hash} )

# Format as nix expression
nix_exp=$(cat <<EOF
{
  version="${version}";
  id="${id}";
  hash="${hash}";
}
EOF
)

echo "${nix_exp}" > version.nix
