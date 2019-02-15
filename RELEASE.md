# Release process

## Shipping a new version

1. Update version in mix.exs

2. Commit changes above with title "Release vVERSION"

3. Open a pull request for release commit.

4. Once merged and CI passes for master,

5. Checkout latest master locally.

6. Create and push a git tag for release.

7. `mix hex.publish`
