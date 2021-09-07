<div align="center">
  <img alt="Banner" width="100%" src="media/banner.png" />
  <h1>bridgetown-gh-pages-action</h1>
  <p>A GitHub Action for building and deploying a <a href="https://www.bridgetownrb.com" target="_blank">Bridgetown site</a> to GitHub Pages.</p>
</div>

## Getting Started

This is intended to be an out-of-the-box solution for deploying your [Bridgetown](https://www.bridgetownrb.com) to [GitHub Pages](https://pages.github.com/).

```yml
- name: Build & Deploy to GitHub Pages
  uses: andrewmcodes/bridgetown-gh-pages-action@v0.0.3
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
```

**:rotating_light: IMPORTANT** Due to the way GitHub Actions work, you cannot pass in a Ruby version to the Docker container that gets built (or at least I can't find a way). **Due to this, this action will build your site with Ruby 2.7.1**. If you cannot upgrade your Ruby version for some reason, I suggest forking this action and adding the Ruby version you need in the Dockerfile, or using a [manual solution](#manual-solution).

## Usage

### Basic

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  build_and_deploy:
    name: Build & Deploy
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build & Deploy to GitHub Pages
        uses: andrewmcodes/bridgetown-gh-pages-action@v0.0.3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Advanced

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  build_and_deploy:
    name: Build & Deploy
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build & Deploy to GitHub Pages
        uses: andrewmcodes/bridgetown-gh-pages-action@v0.0.3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          repository: andrewmcodes/bridgetown-gh-pages-action
          github_actor: octokit
          site_location: "./site"
          build_location: "./site/output"
          deploy_branch: "deploy"
          commit_message: "Release the site"
```

## Inputs

| Name           | Type   | Required? | Default                    | Description                                                              |
| -------------- | ------ | --------- | -------------------------- | ------------------------------------------------------------------------ |
| github_token   | String | true      |                            | Token for the repo. Can be passed in using \${{ secrets.GITHUB_TOKEN }}. |
| repository     | String | false     | `${{ github.repository }}` | The GitHub repository to push the built site to.                         |
| github_actor   | String | false     | `${{ github.actor }}`      | Name of the deploy actor.                                                |
| site_location  | String | false     | `.`                        | Location of the Bridgetown project within your repo.                     |
| build_location | String | false     | `./output`                 | Location of your Bridgetown generated site.                              |
| default_branch | String | false     | `main`                     | The name of your default branch.                                         |
| deploy_branch  | String | false     | `gh-pages`                 | Branch name to push the site to.                                         |
| commit_message | String | false     | `chore: deploy site`       | The commit message that will be used when deploying.                     |

## Manual Solution

If you cannot use this action due to version constraints or other issues, you can do this manually with something like:

```yaml
name: Deploy

on:
  push:
    branches:
      - main

jobs:
  deploy:
    name: Deploy to GitHub Pages
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@master
      - name: Setup Node
        uses: actions/setup-node@v1
        with:
          node-version: "13.x"
      - name: Get yarn cache directory path
        id: yarn-cache-dir-path
        run: echo "::set-output name=dir::$(yarn cache dir)"
      - uses: actions/cache@v1
        id: yarn-cache
        with:
          path: ${{ steps.yarn-cache-dir-path.outputs.dir }}
          key: ${{ runner.os }}-yarn-${{ hashFiles('**/yarn.lock') }}
          restore-keys: |
            ${{ runner.os }}-yarn-
      - name: Set up Ruby 2.7
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: 2.7.1
      - name: Cache gems
        uses: actions/cache@v1
        with:
          path: vendor/bundle
          key: ${{ runner.os }}-gems-${{ hashFiles('**/Gemfile.lock') }}
          restore-keys: |
            ${{ runner.os }}-gems-
      - name: Install Dependencies
        run: |
          bundle config path vendor/bundle
          bundle install --jobs 4 --retry 3
          yarn install
      - name: Build site for deployment
        run: yarn deploy
      - name: Deploy to GitHub Pages
        if: success()
        uses: crazy-max/ghaction-github-pages@v2
        with:
          target_branch: gh-pages
          build_dir: output
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## Demo

[bridgetown-gh-pages-starter](https://github.com/andrewmcodes/bridgetown-gh-pages-starter)

This starter can be used to reproduce issues as well as provide an example of the plugin's usage.

You can view the live version at: [andrewmcodes.github.io/bridgetown-gh-pages-starter](https://andrewmcodes.github.io/bridgetown-gh-pages-starter/).

## Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/andrewmcodes/bridgetown-gh-pages-tag/issues). You can also take a look at the [contributing guide](https://github.com/andrewmcodes/bridgetown-gh-pages-tag/blob/main/CONTRIBUTING.md).

## Releasing

### Update Changelog

**Update**

```sh
conventional-changelog -p angular -i CHANGELOG.md -s
```

**Regenerate**

```sh
conventional-changelog -p angular -i CHANGELOG.md -s -r 0
```

## Extras

### Deploy on Github Pages with Custom Domain.

If you are following the [github documentation for add your custom domain](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site), GitHub adds the **CNAME** file in the `gh-pages` branch but it will get removed everytime you deploy your web page, to solve this issue, add the **CNAME** file into the **src/** folder and it will be deployed as expected.


## License

This plugin is released under the [MIT License](LICENSE).
