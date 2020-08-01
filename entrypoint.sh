#!/bin/sh

set -e

echo "== Installing Dependencies =="

if [ "${INPUT_SITE_LOCATION}" != "." ]; then
  cd "${INPUT_SITE_LOCATION}"
fi

bundle config path vendor/bundle
bundle install --jobs 4 --retry 3
yarn install

echo "== Running Production Build =="
NODE_ENV=production yarn webpack-build && yarn build

echo "== Committing Changes =="
cd "${INPUT_BUILD_LOCATION}"
remote_repo="https://${INPUT_GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${INPUT_REPOSITORY}.git" &&
  deploy_branch=${INPUT_DEPLOY_BRANCH} &&
  default_branch=${INPUT_DEFAULT_BRANCH}
git init
git config user.name "${INPUT_GITHUB_ACTOR}"
git config user.email "${INPUT_GITHUB_ACTOR}@users.noreply.github.com"
git add .

echo -n "Files to Commit:"
ls -l | wc -l
echo "Committing files..."
git commit -m "${INPUT_COMMIT_MESSAGE}" >/dev/null 2>&1

echo "== Deploying =="
echo "Pushing... to $remote_repo $default_branch:$deploy_branch"
git push --force "$remote_repo" "$default_branch":"$deploy_branch" >/dev/null 2>&1

echo "== Cleanup =="
rm -fr .git
cd -

echo "== Done =="
