# Podman Desktop - Red Hat UBI 9 WSL2 Distribution Container Base

Windows Subsystem for Linux (WSL) provides a way to run Linux on Windows.  These little Linux distributions by default use a Microsoft-built kernel, and you can find a variety of distributions available in the Microsoft Store - or you can build your own WSL distribution from any container image, which can be useful when enabling developers in an organization at large.

## Features

- Red Hat Universal Base Image (UBI) 9, the latest and greatest
- Drop-ins for custom Root CAs, Proxy Connections, etc.
- Podman 4, running in Rootless Mode
- Default non-root user creation
- Basic packages such as curl, git, etc.
- Developmental packages, such as make, gcc, etc.
- Python 3.9
- NodeJS 16.x
- Golang 1.17
- PHP 8
- Ansible

## Workflow

1. Build the container image just as you normally would using a Dockerfile
2. Push to a Container Registry
3. Use `buildah` to create the container image tarball
4. Upload the tarball somewhere your Windows systems can access
5. Run a Powershell script to import the tarball into the WSL2 as a new distribution

### Building the Container Image

```bash
podman build -t podman-desktop-ubi9-wsl2 .
```

### Push the Container Image to a Container Registry

```bash
podman push podman-desktop-ubi9-wsl2 quay.io/kenmoini/podman-desktop-ubi9-wsl2:latest
```

### Using `buildah` to Create the Container Image Tarball

```bash
## Fedora/RHEL Install buildah
sudo dnf install -y buildah

## Debian/Ubuntu Install buildah
sudo apt-get install -y buildah

## Switch to the root user
sudo -i

## Instantiate the Image
CONTNR=$(buildah from quay.io/kenmoini/podman-desktop-ubi9-wsl2:latest)

## Mount the image
MNTPNT=$(buildah mount $CONTNR)

## Enter the mount point
cd $MNTPNT

## Create a tar file of the container filesystem, outside of the mounted filesystem
tar cvf /opt/ubi9-init-buildah-base.tar .
```

### Run a Powershell script to Import the Container Image Tarball

```powershell
$distributionName = "ubi9"
$imageSource = "https://server.example.com/pub/ubi9-init-buildah-base.tar"
$wsl_distro_root_path = "C:\WSLDistros\"

## Check for WSL, install if not found
if ((Get-Command "wsl.exe" -ErrorAction SilentlyContinue) -eq $null) 
{
  echo "Unable to find WSL installed!  Installing now..."
  dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
  dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

  ## Set the default version to WSL2
  wsl --set-default-version 2
}

## Create needed directories
if (!(Test-Path $wsl_distro_root_path)) {
  [void](New-Item -ItemType directory -Path $wsl_distro_root_path)
}
if (!(Test-Path $wsl_distro_root_path + "import\")) {
  [void](New-Item -ItemType directory -Path $wsl_distro_root_path + "import\")
}
if (!(Test-Path $wsl_distro_root_path + $distributionName + "\")) {
  [void](New-Item -ItemType directory -Path $wsl_distro_root_path + $distributionName + "\")
}

## Download the tar file
Invoke-WebRequest -Uri $imageSource -OutFile $wsl_distro_root_path + "import\" + $distributionName + ".tar"

## Check to see if the distro has already been imported
if (!(Test-Path -Path $wsl_distro_root_path+$distributionName+"\ext4.vhdx" -PathType Leaf)) {
  ## Import the Image
  wsl --import $distributionName $wsl_distro_root_path+$distributionName+"\" $wsl_distro_root_path+"import\"+$distributionName+".tar"

  ## Test the distribution - will launch the WSL2 distro with the whoami command
  wsl -d $distributionName whoami

  ## Optionally set it as a default
  wsl --set-default $distributionName
}
```
