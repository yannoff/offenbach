# The Offenbach Project

_Boost your [composer](https://getcomposer.org/) with YAML support!_

## Requirements
- bash
- [YAML Tools](https://github.com/yannoff/yamltools) _(the install script will download and install it at build time, if not found on the system)_.

## Install

1. Clone or fetch a zipball from this repository
2. Run `configure bin/offenbach`
3. Run `make`
4. Run `sudo make install`

## Usage

Offenbach behaves exactly as composer, all commands are the same, except for the 2 following points:
- The `composer.json` file is replaced by a `composer.yaml` file
- The `composer.lock` file is replaced by a `composer-lock.yaml` file

## Advisory
- **This is still a work-in-progress**
_No product is perfect from the start, your [feedback](issues) is welcome and encouraged!_

- **Offenbach is not a [composer-plugin](https://getcomposer.org/doc/articles/plugins.md)**

## Credits

Licensed under the [MIT License](LICENSE).
