# Release process

## Shipping a new version

1. ensure CHANGELOG.md is updated and merged into master

2. update version in mix.exs

3. commit changes above with title "Release vVERSION"

4. open a pull request for release commit

5. once merged and CI passes for master

6. checkout latest master locally

7. create and push a git tag for release

8. `mix hex.publish`
