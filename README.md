# TIM quick install scripts

Scripts to install a minimal instance of [TIM](https://github.com/TIM-JYU/TIM).

## Requirements

* One of the following distros
  * Ubuntu LTS
  * Red Hat Enterprise Linux 8 
* Permission to write to `/opt` (script creates `/opt/tim`)
  * In addition to pulling source code (~100 MB), TIM writes all user documents to `/opt/tim/timApp/tim_files` so space requirements are flexible
  * The machine should have at least 20 GB of free space for normal use (<=500 concurrent users)

## Install steps

1. Download the scripts in the repo. The easiest way to do so is with `curl`:

```bash
curl -s https://raw.githubusercontent.com/TIM-JYU/tim-installscripts/master/download.sh | bash
```

2. Run `./<distro>.sh <domain>` name where

  * `<distro>` is the Linux distribution to use. Currently available values are

    * `ubuntu` - Ubuntu LTS
    * `rhel8` - RHEL 8

  * `<domain>` is the domain name that TIM will be connected to. Make sure that the machine you're installing TIM on is reachable via the domain name.

      * You can always change the domain later by editing `/opt/tim/variables.sh`
