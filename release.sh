#!/bin/bash

REPO='belsander/docker-cronicle.git'
VERSION_FILE='VERSION'
VERSION_CMD="docker run -ti intelliops/cronicle:latest \
  /bin/bash -c '/opt/cronicle/bin/control.sh version'"


setup_git() {
  # Configure git credentials for commit messages etc
  git config --global user.email "sander@intelliops.be"
  git config --global user.name "Sander Bel (Travis CI)"
}

get_version() {
  # Get version of binary to be released
  eval "$VERSION_CMD"
}

set_version() {
  # Set version in VERSION_FILE, used for tracking version in GitHub
  echo "$1" > $VERSION_FILE
}

commit_version() {
  # Commit new version in VERSION_FILE
  git add $VERSION_FILE
  git commit --message "Bumped version: $1"
}

tag_version() {
  # Create tag at current commit
  git tag -a "$1"
}

push_changes() {
  # Push local changes to GitHub
  git remote add origin-auth "https://${GH_AUTH}@github.com/$REPO" > /dev/null 2>&1
  git push --tags --quiet --set-upstream origin-auth master
}


# MAIN
setup_git

VERSION=$(get_version)
set_version "$VERSION"
commit_version "$VERSION"
tag_version "$VERSION"

push_changes
