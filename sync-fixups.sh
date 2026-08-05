#!/bin/bash
# Reapply d77void-pkgs local customizations after syncing the tree from
# upstream void-packages (which overwrites files like etc/xbps.d/repos-local.conf
# with the stock version, dropping the d77 local repo entry).
#
# Safe to run multiple times: each fixup only applies if not already present.

set -e

repos_local_conf="etc/xbps.d/repos-local.conf"
d77_repo_line="repository=/host/binpkgs/d77"

if ! grep -qxF "$d77_repo_line" "$repos_local_conf"; then
	echo "$d77_repo_line" >> "$repos_local_conf"
	echo "sync-fixups: added '$d77_repo_line' to $repos_local_conf"
else
	echo "sync-fixups: $repos_local_conf already up to date"
fi
