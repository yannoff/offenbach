#
# @source https://github.com/docker-library/php/blob/master/8.2/bookworm/cli/docker-php-source
#
php_source(){

    dir=/usr/src/php

    case "$1" in
        extract)
            mkdir -p "$dir"
            if [ ! -f "$dir/.docker-extracted" ]; then
                tar -Jxf /usr/src/php.tar.xz -C "$dir" --strip-components=1
                touch "$dir/.docker-extracted"
            fi
            ;;

        delete)
            rm -rf "$dir"
            ;;

        *)
            usage
            exit 1
            ;;
    esac
}

# source: https://github.com/docker-library/php/blob/master/8.2/bookworm/cli/Dockerfile
#

# prevent Debian's PHP packages from being installed
# https://github.com/docker-library/php/pull/542
set -eux;
#	{ \
#		echo 'Package: php*'; \
#		echo 'Pin: release *'; \
#		echo 'Pin-Priority: -1'; \
#	} > /etc/apt/preferences.d/no-debian-php

# dependencies required for running "phpize"
# (see persistent deps below)
export PHPIZE_DEPS="autoconf dpkg-dev file g++ gcc libc-dev  make  pkg-config  re2c"

# persistent / runtime deps
set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		$PHPIZE_DEPS \
		ca-certificates \
		curl \
		xz-utils \
	; \
	rm -rf /var/lib/apt/lists/*

export PHP_INI_DIR=/usr/local/etc/php

set -eux; \
	mkdir -p "$PHP_INI_DIR/conf.d"; \
# allow running as an arbitrary user (https://github.com/docker-library/php/issues/743)
	[ ! -d /var/www/html ]; \
	mkdir -p /var/www/html; \
	chown www-data:www-data /var/www/html; \
	chmod 1777 /var/www/html

# Apply stack smash protection to functions using local buffers and alloca()
# Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
# Enable optimization (-O2)
# Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
# https://github.com/docker-library/php/issues/272
# -D_LARGEFILE_SOURCE and -D_FILE_OFFSET_BITS=64 (https://www.php.net/manual/en/intro.filesystem.php)
export PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2 -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
export PHP_CPPFLAGS="$PHP_CFLAGS"
export PHP_LDFLAGS="-Wl,-O1 -pie"

export GPG_KEYS="39B641343D8C104B2B146DC3F9C39DC0B9698544 E60913E4DF209907D8E30D96659A97C9CF2A795A 1198C0117593497A5EC5C199286AF1F9897469DC"

export PHP_VERSION=8.2.16
export PHP_URL="https://www.php.net/distributions/php-8.2.16.tar.xz"
export PHP_ASC_URL="https://www.php.net/distributions/php-8.2.16.tar.xz.asc"
export PHP_SHA256="28cdc995b7d5421711c7044294885fcde4390c9f67504a994b4cf9bc1b5cc593"

set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends gnupg; \
	rm -rf /var/lib/apt/lists/*; \
	\
	mkdir -p /usr/src; \
	cd /usr/src; \
	\
	curl -fsSL -o php.tar.xz "$PHP_URL"; \
	\
	if [ -n "$PHP_SHA256" ]; then \
		echo "$PHP_SHA256 *php.tar.xz" | sha256sum -c -; \
	fi; \
	\
	if [ -n "$PHP_ASC_URL" ]; then \
		curl -fsSL -o php.tar.xz.asc "$PHP_ASC_URL"; \
		export GNUPGHOME="$(mktemp -d)"; \
		for key in $GPG_KEYS; do \
			gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
		done; \
		gpg --batch --verify php.tar.xz.asc php.tar.xz; \
		gpgconf --kill all; \
		rm -rf "$GNUPGHOME"; \
	fi; \
	\
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark > /dev/null; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false

set -eux; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libargon2-dev \
		libcurl4-openssl-dev \
		libonig-dev \
		libreadline-dev \
		libsodium-dev \
		libsqlite3-dev \
		libssl-dev \
		libxml2-dev \
		zlib1g-dev \
	; \
	\
	export CFLAGS="$PHP_CFLAGS"
    export CPPFLAGS="$PHP_CPPFLAGS"
    export LDFLAGS="$PHP_LDFLAGS"
# https://github.com/php/php-src/blob/d6299206dd828382753453befd1b915491b741c6/configure.ac#L1496-L1511
    export PHP_BUILD_PROVIDER='https://github.com/docker-library/php'
    export PHP_UNAME='Linux - Docker'
	
	php_source extract
	cd /usr/src/php
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
# https://bugs.php.net/bug.php?id=74125
	if [ ! -d /usr/include/curl ]; then \
		ln -sT "/usr/include/$debMultiarch/curl" /usr/local/include/curl; \
	fi; \
	./configure \
		--build="$gnuArch" \
		--with-config-file-path="$PHP_INI_DIR" \
		--with-config-file-scan-dir="$PHP_INI_DIR/conf.d" \
		\
# make sure invalid --configure-flags are fatal errors instead of just warnings
		--enable-option-checking=fatal \
		\
# https://github.com/docker-library/php/issues/439
		--with-mhash \
		\
# https://github.com/docker-library/php/issues/822
		--with-pic \
		\
# --enable-mbstring is included here because otherwise there's no way to get pecl to use it properly (see https://github.com/docker-library/php/issues/195)
		--enable-mbstring \
# --enable-mysqlnd is included here because it's harder to compile after the fact than extensions are (since it's a plugin for several extensions, not an extension in itself)
		--enable-mysqlnd \
# https://wiki.php.net/rfc/argon2_password_hash
		--with-password-argon2 \
# https://wiki.php.net/rfc/libsodium
		--with-sodium=shared \
# always build against system sqlite3 (https://github.com/php/php-src/commit/6083a387a81dbbd66d6316a3a12a63f06d5f7109)
		--with-pdo-sqlite=/usr \
		--with-sqlite3=/usr \
		\
		--with-curl \
		--with-iconv \
		--with-openssl \
		--with-readline \
		--with-zlib \
		\
# https://github.com/docker-library/php/pull/1259
		--enable-phpdbg \
		--enable-phpdbg-readline \
		\
# in PHP 7.4+, the pecl/pear installers are officially deprecated (requiring an explicit "--with-pear")
		--with-pear \
		\
# bundled pcre does not support JIT on s390x
# https://manpages.debian.org/bullseye/libpcre3-dev/pcrejit.3.en.html#AVAILABILITY_OF_JIT_SUPPORT
		$(test "$gnuArch" = 's390x-linux-gnu' && echo '--without-pcre-jit') \
		--with-libdir="lib/$debMultiarch" \
		\
# https://github.com/docker-library/php/pull/939#issuecomment-730501748
		--enable-embed \
	; \
	make -j "$(nproc)"; \
	find -type f -name '*.a' -delete; \
	make install; \
	find \
		/usr/local \
		-type f \
		-perm '/0111' \
		-exec sh -euxc ' \
			strip --strip-all "$@" || : \
		' -- '{}' + \
	; \
	make clean; \
	\
# https://github.com/docker-library/php/issues/692 (copy default example "php.ini" files somewhere easily discoverable)
	cp -v php.ini-* "$PHP_INI_DIR/"; \
	\
	cd /; \
	php_source delete; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	[ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
	find /usr/local -type f -executable -exec ldd '{}' ';' \
		| awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); print so }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
	; \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*; \
	\
# update pecl channel definitions https://github.com/docker-library/php/issues/443
	pecl update-channels; \
	rm -rf /tmp/pear ~/.pearrc; \
	\
# smoke test
	php --version
