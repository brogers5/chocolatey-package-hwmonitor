<!--markdownlint-disable-next-line MD033 MD045 -->
# <img src="https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-hwmonitor@3c97c2c283fd8b4d53191d05b24320cf1d14eaf7/hwmonitor.png" width="48" height="48" alt="HWMonitor icon"/> Chocolatey Package: [HWMonitor](https://community.chocolatey.org/packages/hwmonitor)

[![Latest package version shield](https://img.shields.io/chocolatey/v/hwmonitor.svg)](https://community.chocolatey.org/packages/hwmonitor)
[![Total package download count shield](https://img.shields.io/chocolatey/dt/hwmonitor.svg)](https://community.chocolatey.org/packages/hwmonitor)

---

This package is part of a family of packages published for HWMonitor. This repository is for the meta package.

* For the installer package, see [chocolatey-package-hwmonitor.install](https://github.com/brogers5/chocolatey-package-hwmonitor.install).
* For the portable package, see [chocolatey-package-hwmonitor.portable](https://github.com/brogers5/chocolatey-package-hwmonitor.portable).

See the [Chocolatey FAQs](https://docs.chocolatey.org/en-us/faqs) for more information on [meta packages](https://docs.chocolatey.org/en-us/faqs/#what-is-the-difference-between-packages-no-suffix-as-compared-to-install-portable) and [installer/portable packages](https://docs.chocolatey.org/en-us/faqs#what-distinction-does-chocolatey-make-between-an-installable-and-a-portable-application).

---

## Install

[Install Chocolatey](https://chocolatey.org/install), and run the following command to install the latest approved stable version from the Chocolatey Community Repository:

```shell
choco install hwmonitor --source="'https://community.chocolatey.org/api/v2'"
```

Alternatively, the packages as published on the Chocolatey Community Repository (starting with v1.57.0) will also be mirrored on this repository's [Releases page](https://github.com/brogers5/chocolatey-package-hwmonitor/releases). The `nupkg` can be installed from the current directory as follows:

```shell
choco install hwmonitor --source="'.'"
```

## Build

[Install Chocolatey](https://chocolatey.org/install), clone this repository, and run the following command in the cloned repository:

```shell
choco pack
```

A successful build will create `hwmonitor.x.y.z.nupkg`, where `x.y.z` should be the Nuspec's normalized `version` value at build time.

>[!Note]
>Chocolatey package builds are non-deterministic. Consequently, an independently built package's checksum will not match that of the officially published package.

## Update

This package should be automatically updated by the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au). If it is outdated by more than a few days, please [open an issue](https://github.com/brogers5/chocolatey-package-hwmonitor/issues).

AU expects the parent directory that contains this repository to share a name with the Nuspec (`hwmonitor`). Your local repository should therefore be cloned accordingly:

```shell
git clone git@github.com:brogers5/chocolatey-package-hwmonitor.git hwmonitor
```

Alternatively, a junction point can be created that points to the local repository (preferably within a repository adopting the [AU packages template](https://github.com/majkinetor/au-packages-template)):

```shell
mklink /J hwmonitor ..\chocolatey-package-hwmonitor
```

Once created, simply run `update.ps1` from within the created directory/junction point. Assuming all goes well, all relevant files should change to reflect the latest version available. This will also build a new package version using the modified files.

To forcibly create an updated package (regardless of whether a new software version or package is available), pass the `-Force` switch:

```powershell
.\update.ps1 -Force
```

>[!Note]
>The update script stores the last [`ETag`](https://developer.mozilla.org/docs/Web/HTTP/Headers/ETag) value served with the download, in order to detect possible silent updates (which would require a new package to update the version of the dependent installer package). If a new value is detected, package updates will be forced, even if `-Force` was not passed.

Before submitting a pull request, please [test the package](https://docs.chocolatey.org/en-us/community-repository/moderation/package-verifier#steps-for-each-package) using the [Chocolatey Testing Environment](https://github.com/chocolatey-community/chocolatey-test-environment) first.
