# Changelog

## [0.2.0](https://github.com/theforeman/puppet-pulpcore/tree/0.2.0) (2020-03-19)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/0.1.0...0.2.0)

**Implemented enhancements:**

- Fixes [\#29069](https://projects.theforeman.org/issues/29069) - Apply selinux labels to pulpcore ports [\#72](https://github.com/theforeman/puppet-pulpcore/pull/72) ([wbclark](https://github.com/wbclark))
- Refs [\#28901](https://projects.theforeman.org/issues/28901) - Support SSL connection for external postgresql database [\#71](https://github.com/theforeman/puppet-pulpcore/pull/71) ([wbclark](https://github.com/wbclark))

**Merged pull requests:**

- Pin Facter to \< 4 [\#81](https://github.com/theforeman/puppet-pulpcore/pull/81) ([ekohl](https://github.com/ekohl))
- enable httpd\_can\_network\_connect selinux boolean [\#76](https://github.com/theforeman/puppet-pulpcore/pull/76) ([wbclark](https://github.com/wbclark))
- Prepare acceptance tests for EL8 [\#75](https://github.com/theforeman/puppet-pulpcore/pull/75) ([ekohl](https://github.com/ekohl))
- Fixes [\#28996](https://projects.theforeman.org/issues/28996) - Set PULP\_STATIC\_ROOT [\#69](https://github.com/theforeman/puppet-pulpcore/pull/69) ([wbclark](https://github.com/wbclark))

## [0.1.0](https://github.com/theforeman/puppet-pulpcore/tree/0.1.0) (2020-02-13)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/41659cd46708a5a3ce9bdc5e9071f93fb994161c...0.1.0)

**Closed issues:**

- package installation in plugin.pp should be option [\#59](https://github.com/theforeman/puppet-pulpcore/issues/59)
- configurable REMOTE\_USER\_ENVIRON\_NAME [\#58](https://github.com/theforeman/puppet-pulpcore/issues/58)
- Pulp 2 and 3 API calls through Apache don't play nice [\#49](https://github.com/theforeman/puppet-pulpcore/issues/49)
- Add smoke tests to nightly installer pipelines [\#42](https://github.com/theforeman/puppet-pulpcore/issues/42)
- Check on pulpcore-resource-manager naming and configuration form latest ansible-pulp [\#36](https://github.com/theforeman/puppet-pulpcore/issues/36)
- Update CONTENT\_ORIGIN to match proper value ansible-pulp [\#35](https://github.com/theforeman/puppet-pulpcore/issues/35)
- Make PULP2 mongodb settings configurable [\#33](https://github.com/theforeman/puppet-pulpcore/issues/33)
- Add database migration command  [\#23](https://github.com/theforeman/puppet-pulpcore/issues/23)
- Allow disabling management of Apache via a paramter [\#11](https://github.com/theforeman/puppet-pulpcore/issues/11)
- Support external postgresql [\#10](https://github.com/theforeman/puppet-pulpcore/issues/10)
- Allow specification of externally managed PostgreSQl instance [\#4](https://github.com/theforeman/puppet-pulpcore/issues/4)
- Update to use django-admin solution for pulpcore [\#39](https://github.com/theforeman/puppet-pulpcore/issues/39)
- Update Redis database number to '8' [\#34](https://github.com/theforeman/puppet-pulpcore/issues/34)
- Drop Ansible settings [\#32](https://github.com/theforeman/puppet-pulpcore/issues/32)
- Secret key handling [\#31](https://github.com/theforeman/puppet-pulpcore/issues/31)
- pulp-api fails to start due to permission denied on key [\#22](https://github.com/theforeman/puppet-pulpcore/issues/22)
- The 'gunicorn' command is located at /usr/bin [\#20](https://github.com/theforeman/puppet-pulpcore/issues/20)
- The 'rq' command is located at /usr/bin [\#19](https://github.com/theforeman/puppet-pulpcore/issues/19)
- Manage of user\_home "/var/lib/pulp" clashes with dependency in Katello [\#17](https://github.com/theforeman/puppet-pulpcore/issues/17)
- Drop settings PostgreSQL globals [\#16](https://github.com/theforeman/puppet-pulpcore/issues/16)
- Install from RPM repos rather than PyPI [\#9](https://github.com/theforeman/puppet-pulpcore/issues/9)
- Allow using Redis configured by Foreman [\#7](https://github.com/theforeman/puppet-pulpcore/issues/7)
- Deploy Apache configurations to Foreman vhost [\#5](https://github.com/theforeman/puppet-pulpcore/issues/5)

**Merged pull requests:**

- Refs [\#28901](https://projects.theforeman.org/issues/28901) - add setting postgresql\_db\_user [\#67](https://github.com/theforeman/puppet-pulpcore/pull/67) ([wbclark](https://github.com/wbclark))
- Refs [\#28720](https://projects.theforeman.org/issues/28720) - Fixup migration variables and template [\#66](https://github.com/theforeman/puppet-pulpcore/pull/66) ([wbclark](https://github.com/wbclark))
- Verify everything to have documented parameters [\#65](https://github.com/theforeman/puppet-pulpcore/pull/65) ([ekohl](https://github.com/ekohl))
- Fixes [\#28901](https://projects.theforeman.org/issues/28901) - support external postgresql [\#64](https://github.com/theforeman/puppet-pulpcore/pull/64) ([wbclark](https://github.com/wbclark))
- Refs [\#28720](https://projects.theforeman.org/issues/28720) - move migration params into migration plugin [\#63](https://github.com/theforeman/puppet-pulpcore/pull/63) ([wbclark](https://github.com/wbclark))
- Fixes [\#28904](https://projects.theforeman.org/issues/28904) - make REMOTE\_USER\_ENVIRON\_NAME configurable [\#61](https://github.com/theforeman/puppet-pulpcore/pull/61) ([synkd](https://github.com/synkd))
- Fixes [\#28812](https://projects.theforeman.org/issues/28812) - fix permissions to allow pulp2 access [\#60](https://github.com/theforeman/puppet-pulpcore/pull/60) ([jlsherrill](https://github.com/jlsherrill))
- Fixes [\#28720](https://projects.theforeman.org/issues/28720) - connect to mongo for content migrations [\#57](https://github.com/theforeman/puppet-pulpcore/pull/57) ([wbclark](https://github.com/wbclark))
- Fixes [\#28654](https://projects.theforeman.org/issues/28654) - support client cert auth with pulp3 [\#56](https://github.com/theforeman/puppet-pulpcore/pull/56) ([wbclark](https://github.com/wbclark))
- Run acceptance tests with SCL redis [\#54](https://github.com/theforeman/puppet-pulpcore/pull/54) ([ekohl](https://github.com/ekohl))
- Update pulpcore worker systemd naming [\#53](https://github.com/theforeman/puppet-pulpcore/pull/53) ([ianballou](https://github.com/ianballou))
- use puppet-redis \> 5.0.0 [\#52](https://github.com/theforeman/puppet-pulpcore/pull/52) ([wbclark](https://github.com/wbclark))
- Specify /pulp/api/v3 [\#50](https://github.com/theforeman/puppet-pulpcore/pull/50) ([wbclark](https://github.com/wbclark))
- Use koji in acceptance tests and use python3-django-admin [\#48](https://github.com/theforeman/puppet-pulpcore/pull/48) ([wbclark](https://github.com/wbclark))
- make servername configurable [\#45](https://github.com/theforeman/puppet-pulpcore/pull/45) ([wbclark](https://github.com/wbclark))
- Improve settings. [\#44](https://github.com/theforeman/puppet-pulpcore/pull/44) ([wbclark](https://github.com/wbclark))
- Introduce a pulpcore::admin define [\#43](https://github.com/theforeman/puppet-pulpcore/pull/43) ([ekohl](https://github.com/ekohl))
- Refresh collectstatic on the settings file [\#29](https://github.com/theforeman/puppet-pulpcore/pull/29) ([ekohl](https://github.com/ekohl))
- collectstatic needs --noinput to avoid waiting on user input [\#28](https://github.com/theforeman/puppet-pulpcore/pull/28) ([ehelms](https://github.com/ehelms))
- fixes [\#16](https://projects.theforeman.org/issues/16): Drop postgresql globals [\#26](https://github.com/theforeman/puppet-pulpcore/pull/26) ([ehelms](https://github.com/ehelms))
- fixes [\#23](https://projects.theforeman.org/issues/23): Only run database migrations if they are any pending [\#25](https://github.com/theforeman/puppet-pulpcore/pull/25) ([ehelms](https://github.com/ehelms))
- Install pulpcore from RPM packages + chaining + pg client [\#24](https://github.com/theforeman/puppet-pulpcore/pull/24) ([ekohl](https://github.com/ekohl))
- remove redundant reverse proxy declarations [\#15](https://github.com/theforeman/puppet-pulpcore/pull/15) ([wbclark](https://github.com/wbclark))
- don't enable software collections [\#14](https://github.com/theforeman/puppet-pulpcore/pull/14) ([wbclark](https://github.com/wbclark))
- improve declaration of api and content urls [\#13](https://github.com/theforeman/puppet-pulpcore/pull/13) ([wbclark](https://github.com/wbclark))
- apache vhost can be externally managed [\#12](https://github.com/theforeman/puppet-pulpcore/pull/12) ([wbclark](https://github.com/wbclark))
- fixed default params [\#8](https://github.com/theforeman/puppet-pulpcore/pull/8) ([wbclark](https://github.com/wbclark))
- Creation of initial classes [\#2](https://github.com/theforeman/puppet-pulpcore/pull/2) ([wbclark](https://github.com/wbclark))
- initial setup via modulesync [\#1](https://github.com/theforeman/puppet-pulpcore/pull/1) ([wbclark](https://github.com/wbclark))
- Add file and container plugins [\#30](https://github.com/theforeman/puppet-pulpcore/pull/30) ([ekohl](https://github.com/ekohl))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
