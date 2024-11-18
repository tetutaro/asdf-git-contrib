# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

asdf plugin test git-contrib https://github.com/tetutaro/asdf-git-contrib.git "git --version"
```

Tests are automatically run in GitHub Actions on push and PR.
