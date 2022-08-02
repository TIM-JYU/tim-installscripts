# TIM quick install scripts

Scripts to install a minimal instance of [TIM](https://github.com/TIM-JYU/TIM).

## Requirements

* One of the following distros
  * Ubuntu LTS
  * Red Hat Enterprise Linux 8 
* Permission to write to `/opt` (script creates `/opt/tim`)
  * In addition to pulling source code (~100 MB), TIM writes all user documents to `/opt/tim/timApp/tim_files` so space requirements are flexible
  * The machine should have at least 20 GB of free space for normal use (<=500 concurrent users)

## Installing

### Linux

Example

```bash
curl -s http://get.tim.education/linux.sh | bash -s - --profile prod
```

will download and install TIM into `/opt/tim` for production use. 
`--profile` can be adjusted for different install profiles:

* `prod` - installs dependencies to run TIM in production
* `dev` - installs dependencies to run TIM in development (installs NodeJS and PyCharm for development)

### Windows

Example

```powershell
. { iwr -useb http://get.tim.education/windows.ps1 } | iex; install -Profile prod
```

will download and install TIM into `C:\tim` for production use. 
`-Profile` can be adjusted for different install profiles:

* `prod` - installs dependencies to run TIM in production
* `dev` - installs dependencies to run TIM in development (installs NodeJS and PyCharm for development)