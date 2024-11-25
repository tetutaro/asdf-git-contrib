<div align="center">

# asdf-git-contrib [![Build](https://github.com/tetutaro/asdf-git-contrib/actions/workflows/build.yml/badge.svg)](https://github.com/tetutaro/asdf-git-contrib/actions/workflows/build.yml) [![Lint](https://github.com/tetutaro/asdf-git-contrib/actions/workflows/lint.yml/badge.svg)](https://github.com/tetutaro/asdf-git-contrib/actions/workflows/lint.yml)

[git-contrib](https://git-scm.com/doc) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

- difference from [asdf-git](https://gitlab.com/jcaigitlab/asdf-git)
	- this plugin installs git and its contrib scripts
		- `diff-highlight`
		- `git-jump`

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `autoconf`, `gcc`, `gettext`, `make`, `openssl`, `unzip`

# Install

Plugin:

```shell
asdf plugin add git-contrib
# or
asdf plugin add git-contrib https://github.com/tetutaro/asdf-git-contrib.git
```

git-contrib:

```shell
# Show all installable versions
asdf list-all git-contrib

# Install specific version
asdf install git-contrib latest

# Set a version globally (on your ~/.tool-versions file)
asdf global git-contrib latest

# Now git-contrib commands are available
git --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/tetutaro/asdf-git-contrib/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Tetsutaro Maruyama](https://github.com/tetutaro/)
