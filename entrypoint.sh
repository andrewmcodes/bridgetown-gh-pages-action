#!/bin/sh

# Exit immediately if a pipeline returns a non-zero status.
set -e

REMOTE_REPO="https://${INPUT_GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${INPUT_REPOSITORY}.git"
git clone "$REMOTE_REPO" repo
cd repo

if [ "${INPUT_SITE_LOCATION}" != "." ]; then
  cd "${INPUT_SITE_LOCATION}"
fi

printf "\nInstalling Ruby Dependencies..."
bundle config path vendor/bundle
bundle install --jobs 4 --retry 3 --quiet

printf "\nInstalling Node Dependencies..."
yarn install --silent

printf "\n\nRunning Production Build...\n"
BRIDGETOWN_ENV=production NODE_ENV=production yarn webpack-build && yarn build

printf "\nCommitting Changes...\n"
cd "${INPUT_BUILD_LOCATION}"
git init
git config user.name "${INPUT_GITHUB_ACTOR}"
git config user.email "${INPUT_GITHUB_ACTOR}@users.noreply.github.com"
git add .

printf "Files to Commit...\n"
ls -l | wc -l

printf "\nCommitting files...\n"
git commit -m "${INPUT_COMMIT_MESSAGE}" >/dev/null 2>&1

echo "Pushing... to $REMOTE_REPO HEAD:$INPUT_DEPLOY_BRANCH"
git push --force "$REMOTE_REPO" HEAD:"$INPUT_DEPLOY_BRANCH"

printf "\nDeployed!\n"

printf "\nCleanup...\n"
rm -fr .git
cd ..
rm -fr repo

printf "\nDone..."
