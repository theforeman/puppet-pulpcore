# puppet-pulpcore

Puppet module to set up Pulp 3. The primary goal of the maintainers is to set up Pulp 3 as part of Katello installation, but there's no reason it couldn't be used elsewhere.

The module assumes package repositories are present on the system. For convenience there is a `pulpcore::repo` class which installs from [yum.theforeman.org](https://yum.theforeman.org/pulpcore) (built from [pulpcore-packaging](https://github.com/theforeman/pulpcore-packaging)) but users can use other sources. Installation from pip is not supported.

## Support policy

All supported versions are listed below. For every supported version, acceptance tests run in CI on every supported platform. The module provides no guarantee for multiple versions. Whenever a Pulpcore version is dropped, the module's major version is increased.

Supported operating systems are listed in `metadata.json` but individual releases can divert from that. For example, if Pulpcore x.y drops EL7, it will still be listed in metadata.json until all versions supported by the module have dropped it. Similarly, if x.z adds support for EL9, it'll be listed in `metadata.json` and all versions that don't support EL9 will have a note.

### Pulpcore 3.14

Only supported version.

## Installation layout

Pulpcore doesn't mandate a specific layout so this module creates and manages this. There are some constraints, mostly due to SELinux support.

As part of the installation, it creates a user (default `pulp`) and group (default `pulp`). This user gets a home directory (default `/var/lib/pulp`). There is also a config dir (default `/etc/pulp`) under which a `settings.py` file is created.

The media root (default `/var/lib/pulp/media`) refers to the [MEDIA_ROOT setting](https://docs.djangoproject.com/en/2.2/ref/settings/#media-root). In Pulp this should not be served by Apache. Instead of [MEDIA_URL](https://docs.djangoproject.com/en/2.2/ref/settings/#media-url) Pulp has a dedicated `pulpcore-content` service which can also perform permission checks. Only the Pulp services need to read the files so directory permissions are set to `0750`. Note this default differs from [Pulp's default](https://docs.pulpproject.org/settings.html#media-root). A subdirectory of the home directory allows a stricter lockdown and avoids any risk of uploading media files into the wrong directory.

There are also the [STATIC_ROOT](https://docs.djangoproject.com/en/2.2/ref/settings/#std:setting-STATIC_ROOT) and [STATIC_URL](https://docs.djangoproject.com/en/2.2/ref/settings/#static-url) settings. These serve the static assets used by Pulp. This includes CSS and Javascript for the HTML pages. They're not needed for the application to function, but make browsing the API more convenient.

These is also the `cache_dir` which is used to configure [WORKING_DIRECTORY](https://docs.pulpproject.org/settings.html#working-directory) and [FILE_UPLOAD_TEMP_DIR](https://docs.djangoproject.com/en/2.2/ref/settings/#file-upload-temp-dir). This defaults to `/var/lib/pulp/tmp`. It is strongly recommended that this is on the same filesystem as `MEDIA_ROOT`.

Apache is configured to use an empty directory as docroot (`$apache_docroot`, default `/var/lib/pulp/pulpcore_static`). Doing so prevents Apache from bypassing the Pulp content app. When Apache is not managed, this directory is not managed.

While Pulp can create most of these directories at runtime, they're explicitly managed to set the correct permissions and, if pulpcore-selinux is installed, enforce the correct labels.

This results into the following structure, using `tree -pug`:
```
/
├── [drwxr-xr-x root     root    ]  etc
│   └── [drwxr-xr-x root     pulp    ]  pulp ($config_dir)
│       └── [-rw-r----- root     pulp    ]  settings.py
└── [drwxr-xr-x root     root    ]  var
    └── [drwxr-xr-x root     root    ]  lib
        └── [drwxrwxr-x pulp     pulp    ]  pulp ($user_home)
            ├── [drwxr-xr-x pulp     pulp    ]  assets ($static_root)
            ├── [drwxr-xr-x pulp     pulp    ]  pulpcore_static ($apache_docroot)
            ├── [drwxr-x--- pulp     pulp    ]  media ($media_root)
            └── [drwxr-x--- pulp     pulp    ]  tmp ($cache_dir)
```

## Pulpcore settings

The application will load settings from Django's defaults, Pulpcore's defaults, plus any overrides defined in the settings file at `${config_dir}/settings.py` (default: `/etc/pulp/settings.py`). The Django `diffsettings` tool is useful to check settings which are different from Django's defaults (i.e. all of the Pulpcore defaults which are not present in Django, plus any overrides defined in the settings file):

```shell
PULP_SETTINGS=/etc/pulp/settings.py pulpcore-manager diffsettings
```

For example, to check the current value of a Pulpcore setting such as `WORKER_TTL`:

```shell
PULP_SETTINGS=/etc/pulp/settings.py pulpcore-manager diffsettings | grep WORKER_TTL
```

This is useful for module parameter which configure Pulpcore settings but have an `undef` default, such as `$worker_ttl`.  When the param value is `undef`, the setting is omitted from `settings.py` and therefore Pulpcore's default is used.

## Service setup

The module deploys a few systemd services:
* `pulpcore-api.socket` - A unix socket that listens on `$api_socket_path` (default: `/run/pulpcore-api.sock`). It is owned by the Apache user.
* `pulpcore-api.service` - The actual content service. It is using systemd socket activation.
* `pulpcore-content.socket` - A unix socket that listens on `$content_socket_path` (default: `/run/pulpcore-content.sock`). It is owned by the Apache user.
* `pulpcore-content.service` - The actual content service. It is using systemd socket activation.
* `pulpcore-worker@.service` - A service template allowing multiple workers to be started. Actual workers will be named `pulpcore-worker@%i` where %i is a number starting at 1 and ending at `$worker_count`.

The [systemd socket activated](https://www.freedesktop.org/software/systemd/man/systemd.socket.html) services bind to a unix socket. They are always owned by the Apache user. To find this out this username, it always pulls in the [apache](https://github.com/puppetlabs/puppetlabs-apache) module, even if the vhosts are unmanaged (`$apache_http_vhost` and `$apache_https_vhost` both set to `false`).

Binding to a unix socket with minimal permissions is the most secure since only Apache can connect to Pulp's services. This forces the authentication to happen and prevents [MITM attacks](https://en.wikipedia.org/wiki/Man-in-the-middle_attack). Binding on TCP ports is not supported for this reason.
