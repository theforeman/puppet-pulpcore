# Changelog

## [5.0.0](https://github.com/theforeman/puppet-pulpcore/tree/5.0.0) (2021-07-19)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/4.0.1...5.0.0)

**Breaking changes:**

- Drop Puppet 5 support [\#197](https://github.com/theforeman/puppet-pulpcore/pull/197) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Use REDIS\_URL as a configuration option [\#218](https://github.com/theforeman/puppet-pulpcore/pull/218) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Contain Redis within database [\#216](https://github.com/theforeman/puppet-pulpcore/pull/216) ([ekohl](https://github.com/ekohl))

## [4.0.1](https://github.com/theforeman/puppet-pulpcore/tree/4.0.1) (2021-07-13)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/4.0.0...4.0.1)

**Fixed bugs:**

- Revert "Refs [\#32917](https://projects.theforeman.org/issues/32917) - Don't deploy or configure Redis with new taskin… [\#217](https://github.com/theforeman/puppet-pulpcore/pull/217) ([ehelms](https://github.com/ehelms))

## [4.0.0](https://github.com/theforeman/puppet-pulpcore/tree/4.0.0) (2021-07-12)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/3.4.0...4.0.0)

**Breaking changes:**

- Support 3.14, drop 3.13 [\#208](https://github.com/theforeman/puppet-pulpcore/pull/208) ([ehelms](https://github.com/ehelms))
- Support Pulp 3.13, drop earlier versions [\#202](https://github.com/theforeman/puppet-pulpcore/pull/202) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Fixes [\#32968](https://projects.theforeman.org/issues/32968): Add ability to modify log level [\#212](https://github.com/theforeman/puppet-pulpcore/pull/212) ([ehelms](https://github.com/ehelms))
- Refs [\#32917](https://projects.theforeman.org/issues/32917) - Don't deploy or configure Redis with new tasking system [\#207](https://github.com/theforeman/puppet-pulpcore/pull/207) ([wbclark](https://github.com/wbclark))
- Refs [\#32910](https://projects.theforeman.org/issues/32910): Add ability to enable content caching [\#204](https://github.com/theforeman/puppet-pulpcore/pull/204) ([ehelms](https://github.com/ehelms))
- Fixes [\#32891](https://projects.theforeman.org/issues/32891) - Add feature to enable new tasking system and enable it by default [\#203](https://github.com/theforeman/puppet-pulpcore/pull/203) ([wbclark](https://github.com/wbclark))
- Support version 3.11 [\#201](https://github.com/theforeman/puppet-pulpcore/pull/201) ([ekohl](https://github.com/ekohl))
- Introduce a private socket\_service helper [\#199](https://github.com/theforeman/puppet-pulpcore/pull/199) ([ekohl](https://github.com/ekohl))
- Support Puppet 7 [\#174](https://github.com/theforeman/puppet-pulpcore/pull/174) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Fixes [\#32766](https://projects.theforeman.org/issues/32766) - adds scheme and pulp content path to setting value [\#200](https://github.com/theforeman/puppet-pulpcore/pull/200) ([jjeffers](https://github.com/jjeffers))

## [3.4.0](https://github.com/theforeman/puppet-pulpcore/tree/3.4.0) (2021-05-19)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/2.2.3...3.4.0)

**Implemented enhancements:**

- Allow Puppet 7 compatible versions of mods [\#187](https://github.com/theforeman/puppet-pulpcore/pull/187) ([ekohl](https://github.com/ekohl))
- Refs [\#32383](https://projects.theforeman.org/issues/32383): Configurable client certificate authentication to Pulp [\#186](https://github.com/theforeman/puppet-pulpcore/pull/186) ([ehelms](https://github.com/ehelms))

**Fixed bugs:**

- Fixes [\#32622](https://projects.theforeman.org/issues/32622): Include StdEnvVars, ExportCertData SSL options in Apache [\#193](https://github.com/theforeman/puppet-pulpcore/pull/193) ([ehelms](https://github.com/ehelms))

## [2.2.3](https://github.com/theforeman/puppet-pulpcore/tree/2.2.3) (2021-05-19)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/3.3.0...2.2.3)

## [3.3.0](https://github.com/theforeman/puppet-pulpcore/tree/3.3.0) (2021-04-21)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/3.2.1...3.3.0)

**Implemented enhancements:**

- Fixes [\#31950](https://projects.theforeman.org/issues/31950) - support ansible plugin [\#184](https://github.com/theforeman/puppet-pulpcore/pull/184) ([jlsherrill](https://github.com/jlsherrill))
- Add support for ALLOWED\_CONTENT\_CHECKSUMS [\#183](https://github.com/theforeman/puppet-pulpcore/pull/183) ([jlsherrill](https://github.com/jlsherrill))

## [3.2.1](https://github.com/theforeman/puppet-pulpcore/tree/3.2.1) (2021-04-15)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/3.2.0...3.2.1)

**Fixed bugs:**

- Fixes [\#32309](https://projects.theforeman.org/issues/32309) - pulpcore-manager fails from certain directories [\#181](https://github.com/theforeman/puppet-pulpcore/pull/181) ([ianballou](https://github.com/ianballou))

## [3.2.0](https://github.com/theforeman/puppet-pulpcore/tree/3.2.0) (2021-03-24)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/3.1.0...3.2.0)

**Implemented enhancements:**

- Refs [\#32112](https://projects.theforeman.org/issues/32112) - Match upstream pulp default api service worker timeout [\#179](https://github.com/theforeman/puppet-pulpcore/pull/179) ([wbclark](https://github.com/wbclark))
- Fixes [\#32112](https://projects.theforeman.org/issues/32112) - Configure api service gunicorn worker timeout [\#178](https://github.com/theforeman/puppet-pulpcore/pull/178) ([wbclark](https://github.com/wbclark))
- Pulpcore logging format to include correlation id. [\#175](https://github.com/theforeman/puppet-pulpcore/pull/175) ([jjeffers](https://github.com/jjeffers))

## [3.1.0](https://github.com/theforeman/puppet-pulpcore/tree/3.1.0) (2021-02-09)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/3.0.0...3.1.0)

**Implemented enhancements:**

- Fixes [\#31835](https://projects.theforeman.org/issues/31835): Add disablereuse=on for pulpcore-content service [\#171](https://github.com/theforeman/puppet-pulpcore/pull/171) ([ehelms](https://github.com/ehelms))
- Fixes [\#31815](https://projects.theforeman.org/issues/31815) - Allow setting number of workers for content app [\#170](https://github.com/theforeman/puppet-pulpcore/pull/170) ([ehelms](https://github.com/ehelms))

## [3.0.0](https://github.com/theforeman/puppet-pulpcore/tree/3.0.0) (2021-01-28)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/2.2.2...3.0.0)

**Breaking changes:**

- Support Pulp 3.9, drop earlier versions [\#164](https://github.com/theforeman/puppet-pulpcore/pull/164) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Refs [\#31670](https://projects.theforeman.org/issues/31670) - don't timeout DB migrations [\#163](https://github.com/theforeman/puppet-pulpcore/pull/163) ([evgeni](https://github.com/evgeni))
- Allow setting parameters on the API and Content Apache proxy [\#160](https://github.com/theforeman/puppet-pulpcore/pull/160) ([ehelms](https://github.com/ehelms))
- Increase the secret key size to 50 chars [\#158](https://github.com/theforeman/puppet-pulpcore/pull/158) ([ekohl](https://github.com/ekohl))
- Set the reverse proxy host to the name of the service [\#153](https://github.com/theforeman/puppet-pulpcore/pull/153) ([ehelms](https://github.com/ehelms))

**Fixed bugs:**

- Include pulpcore in pulpcore::apache [\#169](https://github.com/theforeman/puppet-pulpcore/pull/169) ([ehelms](https://github.com/ehelms))
- Fixes [\#31694](https://projects.theforeman.org/issues/31694): systemd service type should be Type [\#165](https://github.com/theforeman/puppet-pulpcore/pull/165) ([ehelms](https://github.com/ehelms))
- Add proxy params to plugin Pulp 2 content routes [\#161](https://github.com/theforeman/puppet-pulpcore/pull/161) ([ehelms](https://github.com/ehelms))
- Fixes [\#31468](https://projects.theforeman.org/issues/31468) - create import/export directories [\#154](https://github.com/theforeman/puppet-pulpcore/pull/154) ([jeremylenz](https://github.com/jeremylenz))

## [2.2.2](https://github.com/theforeman/puppet-pulpcore/tree/2.2.2) (2021-01-21)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/2.2.1...2.2.2)

**Fixed bugs:**

- Fixes [\#31694](https://projects.theforeman.org/issues/31694): systemd service type should be Type [\#166](https://github.com/theforeman/puppet-pulpcore/pull/166) ([ehelms](https://github.com/ehelms))

## [2.2.1](https://github.com/theforeman/puppet-pulpcore/tree/2.2.1) (2020-12-09)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/2.2.0...2.2.1)

**Fixed bugs:**

- Fixes [\#31468](https://projects.theforeman.org/issues/31468) - create import/export directories [\#156](https://github.com/theforeman/puppet-pulpcore/pull/156) ([ehelms](https://github.com/ehelms))

## [2.2.0](https://github.com/theforeman/puppet-pulpcore/tree/2.2.0) (2020-12-07)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/2.1.0...2.2.0)

**Implemented enhancements:**

- Set logoutput to on\_failure for pulpcore::admin [\#148](https://github.com/theforeman/puppet-pulpcore/pull/148) ([ekohl](https://github.com/ekohl))
- Fixes [\#30436](https://projects.theforeman.org/issues/30436) - add allowed\_export\_paths to settings.py [\#147](https://github.com/theforeman/puppet-pulpcore/pull/147) ([jeremylenz](https://github.com/jeremylenz))

**Fixed bugs:**

- Drop selinux module dependency [\#149](https://github.com/theforeman/puppet-pulpcore/pull/149) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Correct allowed\_{export,import}\_paths tests [\#150](https://github.com/theforeman/puppet-pulpcore/pull/150) ([ekohl](https://github.com/ekohl))

## [2.1.0](https://github.com/theforeman/puppet-pulpcore/tree/2.1.0) (2020-11-11)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/2.0.0...2.1.0)

**Implemented enhancements:**

- support /pulp/deb proxying [\#145](https://github.com/theforeman/puppet-pulpcore/pull/145) ([jlsherrill](https://github.com/jlsherrill))
- Add ability to control if services are enabled or active [\#137](https://github.com/theforeman/puppet-pulpcore/pull/137) ([ehelms](https://github.com/ehelms))
- Support Pulpcore 3.7 [\#127](https://github.com/theforeman/puppet-pulpcore/pull/127) ([ekohl](https://github.com/ekohl))

## [2.0.0](https://github.com/theforeman/puppet-pulpcore/tree/2.0.0) (2020-10-29)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/1.2.1...2.0.0)

**Breaking changes:**

- Switch to using a Unix socket bind for API and Content services [\#124](https://github.com/theforeman/puppet-pulpcore/pull/124) ([ehelms](https://github.com/ehelms))
- Fixes [\#30465](https://projects.theforeman.org/issues/30465) - Use libexec wrappers for SELinux [\#116](https://github.com/theforeman/puppet-pulpcore/pull/116) ([ekohl](https://github.com/ekohl))
- Fixes [\#30423](https://projects.theforeman.org/issues/30423) - Change the application layout [\#115](https://github.com/theforeman/puppet-pulpcore/pull/115) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Drop pid files and fix working dirs [\#125](https://github.com/theforeman/puppet-pulpcore/pull/125) ([ekohl](https://github.com/ekohl))
- Add Pulpcore repository class [\#123](https://github.com/theforeman/puppet-pulpcore/pull/123) ([ekohl](https://github.com/ekohl))
- Set docroot to pulpcore_static [\#141](https://github.com/theforeman/puppet-pulpcore/pull/141) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- use absolute paths in unit files [\#129](https://github.com/theforeman/puppet-pulpcore/pull/129) ([wbclark](https://github.com/wbclark))
- Fixes [\#31018](https://projects.theforeman.org/issues/31018) - Force UTF-8 database encoding [\#126](https://github.com/theforeman/puppet-pulpcore/pull/126) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Describe the service setup in README [\#135](https://github.com/theforeman/puppet-pulpcore/pull/135) ([ekohl](https://github.com/ekohl))
- Expand README with more about the support policy. [\#128](https://github.com/theforeman/puppet-pulpcore/pull/128) ([ekohl](https://github.com/ekohl))

## [1.3.0](https://github.com/theforeman/puppet-pulpcore/tree/1.3.0) (2020-09-23)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/1.2.0...1.3.0)

**Implemented enhancements:**

- Handle X-Forwarded-Proto headers [\#120](https://github.com/theforeman/puppet-pulpcore/pull/120) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Manage the static assets via a class [\#121](https://github.com/theforeman/puppet-pulpcore/pull/121) ([ekohl](https://github.com/ekohl))
- Refs [\#30780](https://projects.theforeman.org/issues/30780) - set proper content origin setting [\#119](https://github.com/theforeman/puppet-pulpcore/pull/119) ([jlsherrill](https://github.com/jlsherrill))
-  Fixes [\#30770](https://projects.theforeman.org/issues/30770) - check for the admin user before pw reset [\#118](https://github.com/theforeman/puppet-pulpcore/pull/118) ([jlsherrill](https://github.com/jlsherrill))

## [1.2.0](https://github.com/theforeman/puppet-pulpcore/tree/1.2.0) (2020-08-06)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/1.1.0...1.2.0)

**Implemented enhancements:**

- Fixes [\#29895](https://projects.theforeman.org/issues/29895) - add pulp\_deb plugin [\#112](https://github.com/theforeman/puppet-pulpcore/pull/112) ([m-bucher](https://github.com/m-bucher))
- Use pulpcore-manager [\#111](https://github.com/theforeman/puppet-pulpcore/pull/111) ([ekohl](https://github.com/ekohl))
- Refs [\#30057](https://projects.theforeman.org/issues/30057) - Configure Pulpcore Worker Count [\#100](https://github.com/theforeman/puppet-pulpcore/pull/100) ([wbclark](https://github.com/wbclark))

**Fixed bugs:**

- Add the GPL license text [\#109](https://github.com/theforeman/puppet-pulpcore/pull/109) ([ekohl](https://github.com/ekohl))

## [1.1.0](https://github.com/theforeman/puppet-pulpcore/tree/1.1.0) (2020-06-30)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/1.0.0...1.1.0)

**Implemented enhancements:**

- Use the non-deprecated namedspaced pg function [\#106](https://github.com/theforeman/puppet-pulpcore/pull/106) ([ekohl](https://github.com/ekohl))
- Fixes [\#30059](https://projects.theforeman.org/issues/30059) - Add certguard plugin [\#99](https://github.com/theforeman/puppet-pulpcore/pull/99) ([sjha4](https://github.com/sjha4))
- Fixes [\#29075](https://projects.theforeman.org/issues/29075) - add pulp\_rpm plugin [\#89](https://github.com/theforeman/puppet-pulpcore/pull/89) ([wbclark](https://github.com/wbclark))

**Fixed bugs:**

- Refs [\#30133](https://projects.theforeman.org/issues/30133) - Unconditionally install RHSM for certguard [\#103](https://github.com/theforeman/puppet-pulpcore/pull/103) ([ekohl](https://github.com/ekohl))
- Fixes [\#30133](https://projects.theforeman.org/issues/30133) - Install python3-subscription-manager-rhsm [\#101](https://github.com/theforeman/puppet-pulpcore/pull/101) ([sjha4](https://github.com/sjha4))

**Merged pull requests:**

- Rename the apache vhost to match the project name [\#104](https://github.com/theforeman/puppet-pulpcore/pull/104) ([ekohl](https://github.com/ekohl))

## [1.0.0](https://github.com/theforeman/puppet-pulpcore/tree/1.0.0) (2020-05-14)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/0.2.0...1.0.0)

**Breaking changes:**

- Use modern facts [\#96](https://github.com/theforeman/puppet-pulpcore/issues/96)
- Fixes [\#29371](https://projects.theforeman.org/issues/29371) - Update settings.py for pulpcore3.2 [\#79](https://github.com/theforeman/puppet-pulpcore/pull/79) ([sjha4](https://github.com/sjha4))

**Implemented enhancements:**

- Allow puppet/redis 6.x [\#95](https://github.com/theforeman/puppet-pulpcore/pull/95) ([ekohl](https://github.com/ekohl))
- Revert "Pin Facter to \< 4" [\#86](https://github.com/theforeman/puppet-pulpcore/pull/86) ([ekohl](https://github.com/ekohl))
- Create admin user [\#85](https://github.com/theforeman/puppet-pulpcore/pull/85) ([sjha4](https://github.com/sjha4))
- Allow extlib 5.x [\#84](https://github.com/theforeman/puppet-pulpcore/pull/84) ([mmoll](https://github.com/mmoll))
- Fixes [\#29190](https://projects.theforeman.org/issues/29190) - Support EL8 [\#77](https://github.com/theforeman/puppet-pulpcore/pull/77) ([wbclark](https://github.com/wbclark))

**Fixed bugs:**

- Update pulpcore::admin to use the command parameter if it is passed [\#91](https://github.com/theforeman/puppet-pulpcore/pull/91) ([gcoxmoz](https://github.com/gcoxmoz))

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
