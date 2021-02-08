# Build and deploy

To build and deploy a release, use the following steps:

1. Ensure `src/changelog.md` is updated and merged into the default branch.

2. Once the changelog is already up to date on the default branch, update the Elixir application version in `src/mix.exs`.

3. Commit the above changes with a title like "Release v0.1.0". Where the version number is the one to be deployed.

4. Open a pull request for release commit.

5. Once merged and CI passes for the default branch, check it out locally and create and push a git tag for the release.

6. Once CI passed for the tag, `mix hex.publish`.
