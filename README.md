# The Offenbach Project

_An overlay script for [composer](https://getcomposer.org/), providing support for `composer.yaml` files._

[![Latest stable release](https://img.shields.io/badge/Release-1.7.1-blue)](https://github.com/yannoff/offenbach/releases/latest "Latest stable release")
[![MIT License](https://img.shields.io/badge/License-MIT-lightgrey)](https://github.com/yannoff/offenbach/blob/master/LICENSE "MIT License")

## Purpose

This project was initiated to address the [lack of support](https://github.com/composer/composer/issues/440) for [YAML](https://yaml.org/) format in [composer](https://github.com/composer/composer).

**Indeed, `YAML` has several advantages over `JSON`:**

- It supports **comments**, natively.<br/>
*In the meantime developers must use awful hacks to insert comments in their `JSON` contents, like creating fake `_comment` properties...*

- It's **human-readable**.<br/>
_Ever struggled with a merge conflict on a `composer.lock` file? Tough huh?_

<details>
<summary>
    <i>A concrete example: the <a target="_blank" href="https://github.com/yannoff/yamltools/blob/1.4.5/composer-lock.yaml">yamltools lock file</a>.</i>
</summary>
<br/>

```yaml
#
# This file was generated automatically by Offenbach
# @see https://github.com/yannoff/offenbach for details
#
_readme:
    - 'This file locks the dependencies of your project to a known state'
    - 'Read more about it at https://getcomposer.org/doc/01-basic-usage.md#installing-dependencies'
    - 'This file is @generated automatically'
content-hash: bbb0e45340feb244228603615130c04f
packages:
    -
        name: symfony/polyfill-ctype
        version: v1.19.0
        source:
            type: git
            url: 'https://github.com/symfony/polyfill-ctype.git'
            reference: aed596913b70fae57be53d86faa2e9ef85a2297b
        dist:
            type: zip
            url: 'https://api.github.com/repos/symfony/polyfill-ctype/zipball/aed596913b70fae57be53d86faa2e9ef85a2297b'
            reference: aed596913b70fae57be53d86faa2e9ef85a2297b
            shasum: ''
        require:
            php: '>=5.3.3'
        suggest:
            ext-ctype: 'For best performance'
        type: library
        extra:
            branch-alias:
                dev-main: 1.19-dev
            thanks:
                name: symfony/polyfill
                url: 'https://github.com/symfony/polyfill'
        autoload:
            psr-4:
                Symfony\Polyfill\Ctype\: ''
            files:
                - bootstrap.php
        notification-url: 'https://packagist.org/downloads/'
        license:
            - MIT
        authors:
            -
                name: 'Gert de Pagter'
                email: BackEndTea@gmail.com
            -
                name: 'Symfony Community'
                homepage: 'https://symfony.com/contributors'
        description: 'Symfony polyfill for ctype functions'
        homepage: 'https://symfony.com'
        keywords:
            - compatibility
            - ctype
            - polyfill
            - portable
        support:
            source: 'https://github.com/symfony/polyfill-ctype/tree/v1.19.0'
        funding:
            -
                url: 'https://symfony.com/sponsor'
                type: custom
            -
                url: 'https://github.com/fabpot'
                type: github
            -
                url: 'https://tidelift.com/funding/github/packagist/symfony/symfony'
                type: tidelift
        time: '2020-10-23T09:01:57+00:00'
    -
        name: symfony/yaml
        version: v3.4.47
        source:
            type: git
            url: 'https://github.com/symfony/yaml.git'
            reference: 88289caa3c166321883f67fe5130188ebbb47094
        dist:
            type: zip
            url: 'https://api.github.com/repos/symfony/yaml/zipball/88289caa3c166321883f67fe5130188ebbb47094'
            reference: 88289caa3c166321883f67fe5130188ebbb47094
            shasum: ''
        require:
            php: ^5.5.9|>=7.0.8
            symfony/polyfill-ctype: ~1.8
        conflict:
            symfony/console: '<3.4'
        require-dev:
            symfony/console: ~3.4|~4.0
        suggest:
            symfony/console: 'For validating YAML files using the lint command'
        type: library
        autoload:
            psr-4:
                Symfony\Component\Yaml\: ''
            exclude-from-classmap:
                - /Tests/
        notification-url: 'https://packagist.org/downloads/'
        license:
            - MIT
        authors:
            -
                name: 'Fabien Potencier'
                email: fabien@symfony.com
            -
                name: 'Symfony Community'
                homepage: 'https://symfony.com/contributors'
        description: 'Symfony Yaml Component'
        homepage: 'https://symfony.com'
        support:
            source: 'https://github.com/symfony/yaml/tree/v3.4.47'
        funding:
            -
                url: 'https://symfony.com/sponsor'
                type: custom
            -
                url: 'https://github.com/fabpot'
                type: github
            -
                url: 'https://tidelift.com/funding/github/packagist/symfony/symfony'
                type: tidelift
        time: '2020-10-24T10:57:07+00:00'
    -
        name: yannoff/console
        version: 1.3.1
        source:
            type: git
            url: 'https://github.com/yannoff/console.git'
            reference: a81ecb24f9466684636eea4133e7c7959979220f
        dist:
            type: zip
            url: 'https://api.github.com/repos/yannoff/console/zipball/a81ecb24f9466684636eea4133e7c7959979220f'
            reference: a81ecb24f9466684636eea4133e7c7959979220f
            shasum: ''
        type: library
        autoload:
            psr-4:
                Yannoff\Component\Console\: src/
        notification-url: 'https://packagist.org/downloads/'
        license:
            - MIT
        authors:
            -
                name: Yannoff
                homepage: 'https://github.com/yannoff'
        description: 'A simple, lightweight console implementation for command-line PHP applications.'
        homepage: 'https://github.com/yannoff/console'
        support:
            issues: 'https://github.com/yannoff/console/issues'
            source: 'https://github.com/yannoff/console/tree/1.3.1'
        time: '2022-02-22T18:59:49+00:00'
    -
        name: yannoff/y-a-m-l
        version: 1.1.5
        source:
            type: git
            url: 'https://github.com/yannoff/y-a-m-l.git'
            reference: 78d0dd8e0f81056ba3ed04ac6b825c3464e8fcae
        dist:
            type: zip
            url: 'https://api.github.com/repos/yannoff/y-a-m-l/zipball/78d0dd8e0f81056ba3ed04ac6b825c3464e8fcae'
            reference: 78d0dd8e0f81056ba3ed04ac6b825c3464e8fcae
            shasum: ''
        require:
            ext-json: '*'
        require-dev:
            squizlabs/php_codesniffer: ^3.4
        type: php-library
        autoload:
            psr-4:
                Yannoff\Component\YAML\: src
        notification-url: 'https://packagist.org/downloads/'
        license:
            - MIT
        authors:
            -
                name: Yannoff
                homepage: 'https://github.com/yannoff'
        description: 'Y.A.M.L : Yaml Abstraction Model Layer'
        homepage: 'https://github.com/yannoff/y-a-m-l'
        support:
            issues: 'https://github.com/yannoff/y-a-m-l/issues'
            source: 'https://github.com/yannoff/y-a-m-l/tree/1.1.5'
        time: '2021-09-12T13:59:09+00:00'
packages-dev: []
aliases: []
minimum-stability: stable
stability-flags: []
prefer-stable: false
prefer-lowest: false
platform:
    php: '>=5.6.40'
    ext-json: '*'
platform-dev: []
plugin-api-version: 2.2.0
```
<br/>
</details>

## Requirements
- [PHP](https://www.php.net/)
- [composer](https://getcomposer.org/)
- [bash](https://www.gnu.org/software/bash/) / [shell]() or any equivalent <sup>(1)</sup>
- [curl](https://curl.haxx.se/)
- [yamltools](https://github.com/yannoff/yamltools) <sup>(2)</sup> 

> **<sup>(1)</sup>** _Should also work on [Git Bash](https://gitforwindows.org/) / [MinTTY](https://mintty.github.io/), although it has not been tested hitherto._<br/>
> **<sup>(2)</sup>** _Will be downloaded at build time by the install script if not found on the system._

## Install

### Option A: Using the online installer script

The script can be executed on-the-fly, from the target install directory:

```bash
curl -L -s -o - https://github.com/yannoff/offenbach/releases/latest/download/install.sh | bash
```

_See the [examples](#config-examples) section for customized installation examples._


#### Installer options & corresponding env vars

_The online installer script supports a few configuration options allowing for a more fine-tuned installation._

Option | Default | Description | Env var
--- | --- | --- | ---
`--install-dir` | `$PWD` <br/>_(ie: current directory)_ | Offenbach installation directory **<sup>(3)</sup> <sup>(4)</sup>** | `OFFENBACH_INSTALL_DIR`
`--filename` | `offenbach` | Name of the installed executable | `OFFENBACH_FILENAME`
`--version` | `latest` | Alternative version to install | `OFFENBACH_VERSION`


> **<sup>(3)</sup>** _For `offenbach` to be accessible globally, the install dir **must be** in the `$PATH` system-wide variable._<br/>
> **<sup>(4)</sup>** _The script may be invoked in `sudo` mode if the install dir is not owned by the standard user._<br/>

#### Config examples

##### Example using command-line options:

```bash
curl -SL -o /tmp/install.sh https://github.com/yannoff/offenbach/releases/latest/download/install.sh
sudo /tmp/install.sh --install-dir=/usr/local/bin --filename=offenbach
```

##### Example using env variables:

```bash
url=https://github.com/yannoff/offenbach/releases/latest/download/install.sh
curl -SL -s -o - ${url} | env OFFENBACH_INSTALL_DIR=$HOME/bin OFFENBACH_VERSION=1.6.1 bash
```

### Option B: Installing from sources


```bash
# Fetch the sources from the repository
git clone https://github.com/yannoff/offenbach

# Enter the project's directory
cd offenbach

# Configure installation (5)
./configure bin/offenbach

# Build
make

# Install executable (6)
sudo make install
```

> **<sup>(5)</sup>** _The `--help` option will give a thorough overview of the possible customizations._<br/>
> **<sup>(6)</sup>** _Depending on the install directory set up, `sudo` might not be used._


### Github Action

A [github action](actions/install/action.yaml) version of the installer is also available for integration in CI scripts.

The action will install PHP, composer & offenbach.

Synopsis: use `yannoff/offenbach/actions/install@<release>`.

#### Integration example

_Installing offenbach version 1.7.1 / PHP 8.0_

```yaml
# ...
jobs:
    mycijob1:
        steps:
            - name: Checkout repository
              uses: actions/checkout@v4

            - name: Install PHP & Offenbach
              uses: yannoff/offenbach/actions/install@1.7.1
              with:
                  php-version: 8.0

            - name: Install dependencies (Offenbach)
              run: offenbach install
```

_A concrete working use case can be found in the [phpcc project](https://github.com/yannoff/phpcc/blob/main/.github/workflows/ci.yaml)._ 

## How it works


_Offenbach works exactly as composer, indeed it is just an overlay script, acting as a pass-thru for composer commands._

<!--Offenbach is an overlay shell script to be used in adjonction to composer -->

The key principle is really simple: Offenbach will create 2 temporary JSON files before each operation, feed composer with them, then convert them back to YAML format.

From the user's perspective, the only difference is in the composer files:

- The `composer.json` file is replaced by a `composer.yaml` file
- The `composer.lock` file is replaced by a `composer-lock.yaml` file

However, a few [limitations](#limitations) must be considered.

### Limitations

- `offenbach` only handles **project** composer files **<sup>(7)</sup>**
- projects using `offenbach` instead of `composer` will [not be eligible for publication on packagist](#packagist).
- only `*.json` and `*.yaml` filenames are allowed for the **`COMPOSER`** env var.

> **<sup>(7)</sup>** _The global composer files in `COMPOSER_HOME` are left in their original standard JSON format_.


## Usage

There are 2 major use cases:
- [Creating a new project from scratch](#creating-a-new-project-from-scratch)
- [Migrating an existing composer project](#migrating-an-existing-composer-project)

> :warning: Before proceeding, be sure you have read the [compatibility notice](#compatibility-caveats).

### Creating a new project from scratch

As for a [composer](https://getcomposer.org/) project, run:

```bash
offenbach init
```

After prompting for the usual few questions, [offenbach](https://github.com/yannoff/offenbach) will create the 2 composer files:
- `composer.yaml` (standing for the `composer.json` file)
- `composer-lock.yaml` (standing for the `composer.lock` file)

### Migrating an existing composer project

> **:warning: BEWARE**<br/>
> _Migrating from [composer](https://getcomposer.org/) to  [offenbach](https://github.com/yannoff/offenbach) is a **one-way** operation, there is no possible return to use composer back after the project has been migrated._

In a shell terminal, from the project root (i.e. the directory where the `composer.json` reside), run:

```bash
offenbach migrate
```

> :bulb: *Alternatively, any call to standard composer commands, such as:*
> - `offenbach install`
> - `offenbach update --lock`
>
> *will trigger a migration.*

<!--
As a result, [offenbach](https://github.com/yannoff/offenbach) will build the new `composer.yaml` and `composer-lock.yaml` files upon the former JSON composer files (`composer.json` and `composer.lock`, respectively), then remove the original ones.
-->

As a result, [offenbach](https://github.com/yannoff/offenbach) will use the initial `composer.json` and `composer.lock` files to build their YAML counterparts (`composer.yaml` and `composer-lock.yaml`, respectively), then remove them.


## Compatibility caveats

### Packagist

Since [packagist](https://packagist.org/) analysis is based on the project metadata deduced from the `composer.json` file contents,
it will fail to recognize offenbach's `composer.yaml` file.

As a consequence, projects using offenbach will not be able to publish on [packagist.org](https://packagist.org/).

### PHPStorm

PSR-0 / PSR-4 automatic detection may not work properly on [PhpStorm](https://www.jetbrains.com/phpstorm/), as it is based on the `composer.json` file contents.

### Symfony

Since by default the symfony [Kernel::getProjectDir()](https://github.com/symfony/symfony/blob/c82c997a278b34ce66424163aef24d880cbddd58/src/Symfony/Component/HttpKernel/Kernel.php#L279) method uses the `composer.json` location to find out the project's root directory, it's necessary to override the method.

For instance:

```php
<?php
// src/Kernel.php

namespace App;

use Symfony\Bundle\FrameworkBundle\Kernel\MicroKernelTrait;
use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;
use Symfony\Component\HttpKernel\Kernel as BaseKernel;
use Symfony\Component\Routing\Loader\Configurator\RoutingConfigurator;

class Kernel extends BaseKernel
{
    use MicroKernelTrait;

    // ...

    /**
     * Don't use composer.json to find the project root
     *
     * @return string
     */
    public function getProjectDir()
    {
        return dirname(__DIR__);
    }

    // ...

}
```

### Laravel

The [Application::getNamespace()](https://github.com/laravel/framework/blob/v8.69.0/src/Illuminate/Foundation/Application.php#L1389) method (used by some artisan `make:*` commands to populate PHP code auto-generated from stubs) relies on the `composer.json` contents to find out the application's PSR-4 namespace, and hence must be overriden in a custom Application class.

> ⚠️ **BEWARE**<br/>
> _The `symfony/yaml` component must be part of the dependencies list._<br/>
> _Be sure to add it before implementing the custom `Application` class override:_
>
> ```
> offenbach require symfony/yaml
> ```

For instance:

```php
<?php
// app/Foundation/Application.php

namespace App\Foundation;

// Don't forget to import the Yaml class
use Symfony\Component\Yaml\Yaml;

class Application extends \Illuminate\Foundation\Application
{
    /**
     * Override base method to support offenbach
     *
     * @return string
     *
     * @throws \RuntimeException
     */
    public function getNamespace()
    {
        // ...

        // Original code
        //$composer = json_decode(file_get_contents($this->basePath('composer.json')), true);

        // Replacement: Add support for composer.yaml beside standard composer.json files
        if (file_exists($this->basePath('composer.yaml'))) {
            $composer = Yaml::parseFile($this->basePath('composer.yaml'));
        } else {
            $composer = json_decode(file_get_contents($this->basePath('composer.json')), true);
        }

        // ...
    }
```

Then use the custom class:

```php
// bootstrap/app.php

$app = App\Foundation\Application(
    $_ENV['APP_BASE_PATH'] ?? dirname(__DIR__)
);
```


## Advisory
The project is still in a **high development phase**. _[Feedbacks](issues) are welcome and encouraged!_


## About the project's name

[Jacques Offenbach](https://en.wikipedia.org/wiki/Jacques_Offenbach) (1819-1880) was a German-born French composer of the 19th.<!--, which would be a good definition for this project.-->

## Credits

The concepts behind offenbach were highly inspired by the [igorw/composer-yaml](https://github.com/igorw/composer-yaml) project.

## License

Licensed under the [MIT License](LICENSE).
