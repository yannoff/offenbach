# The Offenbach Project

_An overlay script for [composer](https://getcomposer.org/), providing support for `composer.yaml` files._

[![Latest stable release](https://img.shields.io/badge/Release-1.3.0-blue)](https://github.com/yannoff/offenbach/releases/latest "Latest stable release")
[![MIT License](https://img.shields.io/badge/License-MIT-lightgrey)](https://github.com/yannoff/offenbach/blob/master/LICENSE "MIT License")

## Purpose

This project was initiated to address the [lack of support](https://github.com/composer/composer/issues/440) for [YAML](https://yaml.org/) format in [composer](https://github.com/composer/composer).

**Indeed, `YAML` has several advantages over `JSON`:**

- It supports **comments**, natively.<br/>
*In the meantime developers must use awful hacks to insert comments in their `JSON` contents, like creating fake `_comment` properties...*

- It's **human-readable**.<br/>
_Ever struggled with a merge conflict on a `composer.lock` file? Tough huh?_

## Requirements
- [PHP](https://www.php.net/)
- [composer](https://getcomposer.org/)
- [bash](https://www.gnu.org/software/bash/) / [shell]() or any equivalent <sup>(1)</sup>
- [curl](https://curl.haxx.se/)
- [yamltools](https://github.com/yannoff/yamltools) <sup>(2)</sup> 

> **<sup>(1)</sup>** _Should also work on [Git Bash](https://gitforwindows.org/) / [MinTTY](https://mintty.github.io/), although it has not been tested hitherto._<br/>
> **<sup>(2)</sup>** _Will be downloaded at build time by the install script if not found on the system._

## Install

### Quick install...

Download the latest version of the binary to the directory of your choice. <sup>(3)</sup>

:warning: Make sure the download directory is included in the `$PATH` system-wide variable.

> **<sup>(3)</sup>** _The [yamltools](https://github.com/yannoff/yamltools) binary which is required by offenbach must be downloaded too._

_For instance:_

1. Download yamltools

    ```bash
    curl -Lo ~/bin/yamltools -sSL https://github.com/yannoff/yamltools/releases/latest/download/yamltools
    ```

2. Download offenbach

    ```bash
    curl -Lo ~/bin/offenbach -sSL https://github.com/yannoff/offenbach/releases/latest/download/offenbach
    ```


3. Make the scripts executable:

    ```bash
    $ chmod +x ~/bin/yamltools ~/bin/offenbach
    ```

### ...or install from sources

1. Clone or fetch a [zipball](https://github.com/yannoff/offenbach/archive/master.zip) from this repository
2. Run `./configure bin/offenbach`
3. Run `make`
4. Run `sudo make install` 

_**NOTE:**_<br/>
_Depending on the install directory set up with `./configure`, `sudo` might not be used._<br/>
_For instance, if directory is owned by the standard user:_

```bash
$ ./configure --bindir=$HOME/bin bin/offenbach
$ make
$ make install
```

## How it works


_Offenbach works exactly as composer, indeed it is just an overlay script, acting as a pass-thru for composer commands._

<!--Offenbach is an overlay shell script to be used in adjonction to composer -->

The key principle is really simple: Offenbach will create 2 temporary JSON files before each operation, feed composer with them, then convert them back to YAML format.

From the user's perspective, the only difference is in the composer files:

- The `composer.json` file is replaced by a `composer.yaml` file
- The `composer.lock` file is replaced by a `composer-lock.yaml` file

However, a few [limitations](#limitations) must be considered.

### Limitations

- the **`create-project`** command is not supported yet (See [#9](https://github.com/yannoff/offenbach/issues/9)).
- projects using `offenbach` instead of `composer` will [not be eligible for publication on packagist](#packagist).
- only `*.json` and `*.yaml` filenames are allowed for the **`COMPOSER`** env var


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

> :warning: _**Warning:** migrating from [composer](https://getcomposer.org/) to  [offenbach](https://github.com/yannoff/offenbach) is a **one-way** operation, there is no possible return to use composer back after the project has been migrated._

In a shell terminal, from the project root (i.e. the directory where the `composer.json` reside), run:

```bash
offenbach install
```

or 

```bash
offenbach update --lock
```

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


## Advisory
The project is still in a **high development phase**. _[Feedbacks](issues) are welcome and encouraged!_


## About the project's name

[Jacques Offenbach](https://en.wikipedia.org/wiki/Jacques_Offenbach) (1819-1880) was a German-born French composer of the 19th.<!--, which would be a good definition for this project.-->

## Credits

The concepts behind offenbach were highly inspired by the [igorw/composer-yaml](https://github.com/igorw/composer-yaml) project.

## License

Licensed under the [MIT License](LICENSE).
