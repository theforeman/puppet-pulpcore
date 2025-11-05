# Changelog

## [13.2.0](https://github.com/theforeman/puppet-pulpcore/tree/13.2.0) (2025-11-05)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/13.1.0...13.2.0)

**Implemented enhancements:**

- Allow puppetlabs/apache 13.x [\#393](https://github.com/theforeman/puppet-pulpcore/pull/393) ([shubhamsg199](https://github.com/shubhamsg199))
- Allow puppet/redis 12.x [\#390](https://github.com/theforeman/puppet-pulpcore/pull/390) ([evgeni](https://github.com/evgeni))
- Allow puppet/systemd 9.x [\#389](https://github.com/theforeman/puppet-pulpcore/pull/389) ([evgeni](https://github.com/evgeni))

## [13.1.0](https://github.com/theforeman/puppet-pulpcore/tree/13.1.0) (2025-09-09)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/13.0.0...13.1.0)

**Implemented enhancements:**

- install amcheck extension for PostgreSQL [\#387](https://github.com/theforeman/puppet-pulpcore/pull/387) ([evgeni](https://github.com/evgeni))

**Fixed bugs:**

- Fixes [\#38679](https://projects.theforeman.org/issues/38679) - Handle overlapping import & export paths [\#386](https://github.com/theforeman/puppet-pulpcore/pull/386) ([ekohl](https://github.com/ekohl))

## [13.0.0](https://github.com/theforeman/puppet-pulpcore/tree/13.0.0) (2025-08-08)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/12.1.0...13.0.0)

**Breaking changes:**

- Drop EnvironmentFile from pulpcore-worker@.service [\#384](https://github.com/theforeman/puppet-pulpcore/pull/384) ([evgeni](https://github.com/evgeni))

**Implemented enhancements:**

- Add support for Pulpcore 3.73 [\#382](https://github.com/theforeman/puppet-pulpcore/pull/382) ([Odilhao](https://github.com/Odilhao))

**Fixed bugs:**

- Use pulpcore-worker entrypoint directly, without a wrapper [\#383](https://github.com/theforeman/puppet-pulpcore/pull/383) ([evgeni](https://github.com/evgeni))

## [12.1.0](https://github.com/theforeman/puppet-pulpcore/tree/12.1.0) (2025-05-08)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/12.0.0...12.1.0)

**Implemented enhancements:**

- Allow puppet/systemd 8.x [\#380](https://github.com/theforeman/puppet-pulpcore/pull/380) ([evgeni](https://github.com/evgeni))

**Fixed bugs:**

- correctly set X-FORWARDED-PROTO header [\#376](https://github.com/theforeman/puppet-pulpcore/pull/376) ([evgeni](https://github.com/evgeni))

## [12.0.0](https://github.com/theforeman/puppet-pulpcore/tree/12.0.0) (2025-02-12)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/11.0.0...12.0.0)

**Breaking changes:**

- Drop support for Pulpcore 3.39 [\#371](https://github.com/theforeman/puppet-pulpcore/pull/371) ([evgeni](https://github.com/evgeni))
- Drop EL8 support -- Foreman doesn't support it anymore [\#369](https://github.com/theforeman/puppet-pulpcore/pull/369) ([evgeni](https://github.com/evgeni))
- Enable FLATPAK\_INDEX for pulp registry [\#363](https://github.com/theforeman/puppet-pulpcore/pull/363) ([lfu](https://github.com/lfu))

**Implemented enhancements:**

- Add support for Pulpcore 3.63 [\#370](https://github.com/theforeman/puppet-pulpcore/pull/370) ([evgeni](https://github.com/evgeni))

**Fixed bugs:**

- use the right username when computing the db password hash [\#373](https://github.com/theforeman/puppet-pulpcore/pull/373) ([evgeni](https://github.com/evgeni))
- always compare CNs as downcase [\#364](https://github.com/theforeman/puppet-pulpcore/pull/364) ([evgeni](https://github.com/evgeni))

## [11.0.0](https://github.com/theforeman/puppet-pulpcore/tree/11.0.0) (2024-11-04)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/10.4.0...11.0.0)

**Breaking changes:**

- never set REMOTE\_USER to the value of SSL\_CLIENT\_S\_DN\_CN [\#360](https://github.com/theforeman/puppet-pulpcore/pull/360) ([evgeni](https://github.com/evgeni))

**Fixed bugs:**

- properly escape quotes in passwords by calling to\_python [\#361](https://github.com/theforeman/puppet-pulpcore/pull/361) ([evgeni](https://github.com/evgeni))
- Add Wants=postgresql.service to Pulpcore service files [\#359](https://github.com/theforeman/puppet-pulpcore/pull/359) ([ekohl](https://github.com/ekohl))

## [10.4.0](https://github.com/theforeman/puppet-pulpcore/tree/10.4.0) (2024-09-04)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/10.3.0...10.4.0)

**Implemented enhancements:**

- Reuse headers from pulpcore::apache class [\#354](https://github.com/theforeman/puppet-pulpcore/pull/354) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Don't use underscores in HTTP headers [\#357](https://github.com/theforeman/puppet-pulpcore/pull/357) ([evgeni](https://github.com/evgeni))

## [10.3.0](https://github.com/theforeman/puppet-pulpcore/tree/10.3.0) (2024-08-14)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/10.2.0...10.3.0)

**Implemented enhancements:**

- explicitly support Pulpcore 3.49 [\#352](https://github.com/theforeman/puppet-pulpcore/pull/352) ([evgeni](https://github.com/evgeni))

**Fixed bugs:**

- Always run pulpcore-manager migrate [\#351](https://github.com/theforeman/puppet-pulpcore/pull/351) ([evgeni](https://github.com/evgeni))

## [10.2.0](https://github.com/theforeman/puppet-pulpcore/tree/10.2.0) (2024-08-12)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/10.1.0...10.2.0)

**Implemented enhancements:**

- Update puppet\_metadata to ~\> 4.0 and voxpupuli-acceptance to ~\> 3.0 [\#347](https://github.com/theforeman/puppet-pulpcore/pull/347) ([archanaserver](https://github.com/archanaserver))
- Add ability to configure auth backends and classes [\#346](https://github.com/theforeman/puppet-pulpcore/pull/346) ([Scnaeg](https://github.com/Scnaeg))
- Add AlmaLinux 8 & 9 support [\#345](https://github.com/theforeman/puppet-pulpcore/pull/345) ([archanaserver](https://github.com/archanaserver))

## [10.1.0](https://github.com/theforeman/puppet-pulpcore/tree/10.1.0) (2024-05-16)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/10.0.0...10.1.0)

**Implemented enhancements:**

- Allow puppet/redis 11.x and puppet/systemd 7.x [\#339](https://github.com/theforeman/puppet-pulpcore/pull/339) ([evgeni](https://github.com/evgeni))
- use `migrate --check` not `migrate --plan |grep` check for migrations [\#338](https://github.com/theforeman/puppet-pulpcore/pull/338) ([evgeni](https://github.com/evgeni))
- Allow puppetlabs/apache 12.x [\#334](https://github.com/theforeman/puppet-pulpcore/pull/334) ([evgeni](https://github.com/evgeni))
- Allow setting baseurl fact during acceptance tests [\#333](https://github.com/theforeman/puppet-pulpcore/pull/333) ([Odilhao](https://github.com/Odilhao))

**Fixed bugs:**

- Fixes [\#37308](https://projects.theforeman.org/issues/37308) - set REMOTE\_USER properly for pulpcore registry [\#337](https://github.com/theforeman/puppet-pulpcore/pull/337) ([ianballou](https://github.com/ianballou))

## [10.0.0](https://github.com/theforeman/puppet-pulpcore/tree/10.0.0) (2024-02-19)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/9.0.0...10.0.0)

**Breaking changes:**

- Fixes [\#37062](https://projects.theforeman.org/issues/37062) - Rename pulpcore::telemetry to pulpcore::analytics [\#326](https://github.com/theforeman/puppet-pulpcore/pull/326) ([wbclark](https://github.com/wbclark))

**Implemented enhancements:**

- Mark compatible with puppet/redis 10.x [\#330](https://github.com/theforeman/puppet-pulpcore/pull/330) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Ensure glibc-langpack-en is always installed [\#329](https://github.com/theforeman/puppet-pulpcore/pull/329) ([evgeni](https://github.com/evgeni))
- Drop pulpcore::plugin::migration [\#325](https://github.com/theforeman/puppet-pulpcore/pull/325) ([ekohl](https://github.com/ekohl))

## [9.0.0](https://github.com/theforeman/puppet-pulpcore/tree/9.0.0) (2023-11-28)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/8.6.0...9.0.0)

**Breaking changes:**

- Fixes [\#36902](https://projects.theforeman.org/issues/36902) - Support Pulpcore 3.39, drop older versions [\#315](https://github.com/theforeman/puppet-pulpcore/pull/315) ([ianballou](https://github.com/ianballou))

**Implemented enhancements:**

- Use the yumrepo type to manage the repository & expose more params [\#320](https://github.com/theforeman/puppet-pulpcore/pull/320) ([ekohl](https://github.com/ekohl))
- Support nightly repository version [\#318](https://github.com/theforeman/puppet-pulpcore/pull/318) ([ehelms](https://github.com/ehelms))

## [8.6.0](https://github.com/theforeman/puppet-pulpcore/tree/8.6.0) (2023-11-15)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/8.5.0...8.6.0)

**Implemented enhancements:**

- Mark compatible with puppetlabs/postgresql 10.x [\#316](https://github.com/theforeman/puppet-pulpcore/pull/316) ([ekohl](https://github.com/ekohl))
- Mark compatible with puppet-extlib 7.x [\#314](https://github.com/theforeman/puppet-pulpcore/pull/314) ([ekohl](https://github.com/ekohl))
- Mark compatible with puppet/systemd 6.x [\#313](https://github.com/theforeman/puppet-pulpcore/pull/313) ([ekohl](https://github.com/ekohl))
- Mark compatible with puppetlabs/apache 11.x [\#308](https://github.com/theforeman/puppet-pulpcore/pull/308) ([ekohl](https://github.com/ekohl))
- Add Puppet 8 support [\#297](https://github.com/theforeman/puppet-pulpcore/pull/297) ([bastelfreak](https://github.com/bastelfreak))

## [8.5.0](https://github.com/theforeman/puppet-pulpcore/tree/8.5.0) (2023-09-18)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/8.4.0...8.5.0)

**Implemented enhancements:**

- Refs [\#36709](https://projects.theforeman.org/issues/36709) - Expose ANSIBLE\_PERMISSION\_CLASSES setting [\#304](https://github.com/theforeman/puppet-pulpcore/pull/304) ([ekohl](https://github.com/ekohl))

## [8.4.0](https://github.com/theforeman/puppet-pulpcore/tree/8.4.0) (2023-08-22)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/8.3.0...8.4.0)

**Implemented enhancements:**

- allow configuring IMPORT\_WORKERS\_PERCENT [\#302](https://github.com/theforeman/puppet-pulpcore/pull/302) ([evgeni](https://github.com/evgeni))
- don't setup ansible-29 repo in acceptance tests [\#301](https://github.com/theforeman/puppet-pulpcore/pull/301) ([evgeni](https://github.com/evgeni))

## [8.3.0](https://github.com/theforeman/puppet-pulpcore/tree/8.3.0) (2023-08-16)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/8.2.0...8.3.0)

**Implemented enhancements:**

- Support Pulp 3.28 [\#299](https://github.com/theforeman/puppet-pulpcore/pull/299) ([ekohl](https://github.com/ekohl))
- puppetlabs/stdlib: Allow 9.x & puppet/systemd: Allow 5.x & puppetlabs/concat: Allow 9.x [\#296](https://github.com/theforeman/puppet-pulpcore/pull/296) ([bastelfreak](https://github.com/bastelfreak))
- Relax max\_requests [\#295](https://github.com/theforeman/puppet-pulpcore/pull/295) ([dralley](https://github.com/dralley))

## [8.2.0](https://github.com/theforeman/puppet-pulpcore/tree/8.2.0) (2023-06-20)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/8.1.0...8.2.0)

**Implemented enhancements:**

- allow configuring HIDE\_GUARDED\_DISTRIBUTIONS setting [\#292](https://github.com/theforeman/puppet-pulpcore/pull/292) ([evgeni](https://github.com/evgeni))
- allow puppet/redis 9.x [\#291](https://github.com/theforeman/puppet-pulpcore/pull/291) ([evgeni](https://github.com/evgeni))

## [8.1.0](https://github.com/theforeman/puppet-pulpcore/tree/8.1.0) (2023-05-26)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/8.0.0...8.1.0)

**Implemented enhancements:**

- Fixes [\#36438](https://projects.theforeman.org/issues/36438) - configure API request limit to avoid memory leaks [\#289](https://github.com/theforeman/puppet-pulpcore/pull/289) ([evgeni](https://github.com/evgeni))
- Fixes [\#36437](https://projects.theforeman.org/issues/36437) - preload pulpcore API and content code [\#288](https://github.com/theforeman/puppet-pulpcore/pull/288) ([evgeni](https://github.com/evgeni))
- use `--workers` instead of `-w` when configuring gunicorn workers [\#287](https://github.com/theforeman/puppet-pulpcore/pull/287) ([evgeni](https://github.com/evgeni))

## [8.0.0](https://github.com/theforeman/puppet-pulpcore/tree/8.0.0) (2023-05-15)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/7.2.0...8.0.0)

**Breaking changes:**

- Refs [\#36345](https://projects.theforeman.org/issues/36345) - Raise minimum Puppet version to 7.0.0 [\#281](https://github.com/theforeman/puppet-pulpcore/pull/281) ([ekohl](https://github.com/ekohl))
- Drop Pulpcore 3.16 - 3.18, add EL 9 support [\#277](https://github.com/theforeman/puppet-pulpcore/pull/277) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Mark compatible with puppetlabs/postgresql 9.x & puppetlabs/apache 10.x & puppetlabs/concat 8.x [\#280](https://github.com/theforeman/puppet-pulpcore/pull/280) ([ekohl](https://github.com/ekohl))
- Mark compatible with puppet-systemd 4 [\#278](https://github.com/theforeman/puppet-pulpcore/pull/278) ([ekohl](https://github.com/ekohl))

**Merged pull requests:**

- Pin Puppet in CI [\#279](https://github.com/theforeman/puppet-pulpcore/pull/279) ([ekohl](https://github.com/ekohl))

## [7.2.0](https://github.com/theforeman/puppet-pulpcore/tree/7.2.0) (2023-03-06)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/7.1.0...7.2.0)

**Implemented enhancements:**

- Fixes [\#36030](https://projects.theforeman.org/issues/36030) - Ensure HStore is enabled for Pulp 3.22 support [\#275](https://github.com/theforeman/puppet-pulpcore/pull/275) ([ekohl](https://github.com/ekohl))
- Add param for unsafe advisory conflict resolution [\#274](https://github.com/theforeman/puppet-pulpcore/pull/274) ([m-bucher](https://github.com/m-bucher))

## [7.1.0](https://github.com/theforeman/puppet-pulpcore/tree/7.1.0) (2022-12-13)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/7.0.1...7.1.0)

**Implemented enhancements:**

- Remove unused CONTENT\_HOST setting [\#271](https://github.com/theforeman/puppet-pulpcore/pull/271) ([ekohl](https://github.com/ekohl))
- Expose Apache server aliases as a parameter [\#269](https://github.com/theforeman/puppet-pulpcore/pull/269) ([ekohl](https://github.com/ekohl))

**Fixed bugs:**

- Fix broken links in `README.md` [\#273](https://github.com/theforeman/puppet-pulpcore/pull/273) ([alexjfisher](https://github.com/alexjfisher))

## [7.0.1](https://github.com/theforeman/puppet-pulpcore/tree/7.0.1) (2022-11-02)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/7.0.0...7.0.1)

**Fixed bugs:**

- Refs [\#35607](https://projects.theforeman.org/issues/35607) - convert telemetry value to python [\#268](https://github.com/theforeman/puppet-pulpcore/pull/268) ([wbclark](https://github.com/wbclark))

## [7.0.0](https://github.com/theforeman/puppet-pulpcore/tree/7.0.0) (2022-10-28)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/6.0.0...7.0.0)

**Breaking changes:**

- Drop EL7 support [\#257](https://github.com/theforeman/puppet-pulpcore/pull/257) ([ehelms](https://github.com/ehelms))

**Implemented enhancements:**

- Fixes [\#35607](https://projects.theforeman.org/issues/35607) - Configure Pulpcore's TELEMETRY setting [\#267](https://github.com/theforeman/puppet-pulpcore/pull/267) ([wbclark](https://github.com/wbclark))
- Add pulpcore 3.21 support [\#266](https://github.com/theforeman/puppet-pulpcore/pull/266) ([sjha4](https://github.com/sjha4))
- Add a loggers parameter and set default loggers [\#265](https://github.com/theforeman/puppet-pulpcore/pull/265) ([ekohl](https://github.com/ekohl))
- Fixes [\#35496](https://projects.theforeman.org/issues/35496) - Add default pulp\_deb config [\#263](https://github.com/theforeman/puppet-pulpcore/pull/263) ([quba42](https://github.com/quba42))
- Allow puppetlabs/apache 8.x [\#261](https://github.com/theforeman/puppet-pulpcore/pull/261) ([ekohl](https://github.com/ekohl))
- Update to voxpupuli-test 5 [\#258](https://github.com/theforeman/puppet-pulpcore/pull/258) ([ekohl](https://github.com/ekohl))
- Add Pulpcore 3.18 support [\#256](https://github.com/theforeman/puppet-pulpcore/pull/256) ([ianballou](https://github.com/ianballou))

**Fixed bugs:**

- Fixes [\#35390](https://projects.theforeman.org/issues/35390) - set ANSIBLE\_API\_HOSTNAME \*with\* scheme [\#262](https://github.com/theforeman/puppet-pulpcore/pull/262) ([evgeni](https://github.com/evgeni))

## [6.0.0](https://github.com/theforeman/puppet-pulpcore/tree/6.0.0) (2022-04-20)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/5.2.1...6.0.0)

**Breaking changes:**

- Drop Pulpcore 3.14 & 3.15, move to 3.16 and 3.17 [\#249](https://github.com/theforeman/puppet-pulpcore/pull/249) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Fixes [\#34684](https://projects.theforeman.org/issues/34684) - install pulp-cli [\#252](https://github.com/theforeman/puppet-pulpcore/pull/252) ([evgeni](https://github.com/evgeni))
- Allow extlib 6.x, apache 7.x, stdlib 8.x, postgresql 8.x [\#246](https://github.com/theforeman/puppet-pulpcore/pull/246) ([ekohl](https://github.com/ekohl))

## [5.2.1](https://github.com/theforeman/puppet-pulpcore/tree/5.2.1) (2022-02-03)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/5.2.0...5.2.1)

**Fixed bugs:**

- Fixes [\#34379](https://projects.theforeman.org/issues/34379) - Create the Pulp group as a system group [\#244](https://github.com/theforeman/puppet-pulpcore/pull/244) ([ekohl](https://github.com/ekohl))

## [5.2.0](https://github.com/theforeman/puppet-pulpcore/tree/5.2.0) (2022-01-25)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/5.1.0...5.2.0)

**Implemented enhancements:**

- Fixes [\#34298](https://projects.theforeman.org/issues/34298) - support KEEP\_CHANGELOG\_LIMIT option [\#242](https://github.com/theforeman/puppet-pulpcore/pull/242) ([wbclark](https://github.com/wbclark))

## [5.1.0](https://github.com/theforeman/puppet-pulpcore/tree/5.1.0) (2021-10-29)

[Full Changelog](https://github.com/theforeman/puppet-pulpcore/compare/5.0.0...5.1.0)

**Implemented enhancements:**

- Fixes [\#33766](https://projects.theforeman.org/issues/33766) - Support Pulpcore 3.15 [\#238](https://github.com/theforeman/puppet-pulpcore/pull/238) ([ekohl](https://github.com/ekohl))
- Fixes [\#33765](https://projects.theforeman.org/issues/33765) - Use a system user without a login shell [\#237](https://github.com/theforeman/puppet-pulpcore/pull/237) ([ekohl](https://github.com/ekohl))
- Refs [\#33751](https://projects.theforeman.org/issues/33751) - support ostree and python [\#236](https://github.com/theforeman/puppet-pulpcore/pull/236) ([jlsherrill](https://github.com/jlsherrill))
- Fixes [\#33733](https://projects.theforeman.org/issues/33733) - generate key for db encryption [\#235](https://github.com/theforeman/puppet-pulpcore/pull/235) ([jlsherrill](https://github.com/jlsherrill))
- use provides, not the python package name for plugins [\#233](https://github.com/theforeman/puppet-pulpcore/pull/233) ([evgeni](https://github.com/evgeni))
- Fixes [\#33445](https://projects.theforeman.org/issues/33445): Increase default API gunicorn worker count [\#231](https://github.com/theforeman/puppet-pulpcore/pull/231) ([jlsherrill](https://github.com/jlsherrill))
- Fixes [\#33446](https://projects.theforeman.org/issues/33446) - Allow configuring Pulpcore worker timeout [\#230](https://github.com/theforeman/puppet-pulpcore/pull/230) ([wbclark](https://github.com/wbclark))
- Switch to puppet/systemd & allow puppet/redis 8 [\#228](https://github.com/theforeman/puppet-pulpcore/pull/228) ([ekohl](https://github.com/ekohl))
- Fixes [\#33687](https://projects.theforeman.org/issues/33687) - Add warning not to directly edit settings.py [\#223](https://github.com/theforeman/puppet-pulpcore/pull/223) ([wbclark](https://github.com/wbclark))

**Fixed bugs:**

- Fixes [\#33744](https://projects.theforeman.org/issues/33744) - notify the socket service when the DB changes [\#234](https://github.com/theforeman/puppet-pulpcore/pull/234) ([evgeni](https://github.com/evgeni))

**Closed issues:**

- Ordering issue when adding repository [\#225](https://github.com/theforeman/puppet-pulpcore/issues/225)

## [5.0.0](https://github.com/theforeman/puppet-pulpcore/tree/5.0.0) (2021-07-27)

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
