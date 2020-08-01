# bridgetown-gh-pages-action

> A GitHub Action for building and deploying a Bridgetown site to GitHub Pages.

## Inputs

| Name           | Type   | Required? | Default                    | Description                                                              |
| -------------- | ------ | --------- | -------------------------- | ------------------------------------------------------------------------ |
| github_token   | String | true      |                            | Token for the repo. Can be passed in using \${{ secrets.GITHUB_TOKEN }}. |
| repository     | String | false     | `${{ github.repository }}` | The GitHub repository to push the built site to.                         |
| github_actor   | String | false     | `${{ github.actor }}`      | Name of the deploy actor.                                                |
| site_location  | String | false     | `.`                        | Location of the Bridgetown project within your repo.                     |
| build_location | String | false     | `./output`                 | Location of your Bridgetown generated site.                              |
| deploy_branch  | String | false     | `gh-pages`                 | Branch name to push the site to.                                         |
| ruby_version   | String | false     | `2.7.1`                    | The Ruby version you want to use to build the site.                      |
| commit_message | String | false     | `chore: deploy site`       | The commit message that will be used when deploying.                     |

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
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
        uses: andrewmcodes/bridgetown-gh-pages-action@v0.0.1
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
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          repository: andrewmcodes/bridgetown-gh-pages-action
          github_actor: octokit
          site_location: "./site"
          build_location: "./site/output"
          deploy_branch: "deploy"
          ruby_version: "2.7.0"
          commit_message: "Release the site"
        uses: andrewmcodes/bridgetown-gh-pages-action@v0.0.1
```

## Changelog

[View our Changelog][changelog]

## Contributing

[Contributing Guide][contributing]

## Code of Conduct

[Code of Conduct][coc]

## License

[MIT][license]
