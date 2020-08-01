#!/bin/sh

set -e

REMOTE_REPO="https://${INPUT_GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${INPUT_REPOSITORY}.git"
git clone "$REMOTE_REPO" repo
cd repo

if [ "${INPUT_SITE_LOCATION}" != "." ]; then
  cd "${INPUT_SITE_LOCATION}"
fi

echo "== Installing Ruby Dependencies =="
bundle config path vendor/bundle
bundle install --jobs 4 --retry 3 --quiet

echo "== Installing Node Dependencies =="
yarn install --silent

echo "== Running Production Build =="
BRIDGETOWN_ENV=production NODE_ENV=production yarn webpack-build && yarn build

echo "== Committing Changes =="
cd "${INPUT_BUILD_LOCATION}"
git init
git config user.name "${INPUT_GITHUB_ACTOR}"
git config user.email "${INPUT_GITHUB_ACTOR}@users.noreply.github.com"
git add .

echo "Files to Commit:"
ls -l | wc -l

echo "Committing files..."
git commit -m "${INPUT_COMMIT_MESSAGE}" >/dev/null 2>&1

echo "== Deploying =="
echo "Pushing... to $REMOTE_REPO HEAD:$INPUT_DEPLOY_BRANCH"
git push --force "$REMOTE_REPO" HEAD:"$INPUT_DEPLOY_BRANCH"

echo "== Cleanup =="
rm -fr .git
cd ..
rm -fr repo
echo "== Done =="
