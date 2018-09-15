#!bin/bash

function makeChroot
{
  chrootPath=$1
  set -x
  sudo mkdir $chrootPath
  sudo pacstrap -i -c -d $chrootPath base base-devel zsh zsh-completions grml-zsh-config sudo --ignore linux
  sudo mkdir $chrootPath/home/$(whoami)
  sudo chown $(whoami) $chrootPath/home/$(whoami)
  sudo mkdir $chrootPath/home/$(whoami)/Documents
  sudo mkdir $chrootPath/home/$(whoami)/old
  copyUser $chrootPath
  set +x
}

function copyUser
{
  chrootPath=$1
  sudo cp /etc/passwd $chrootPath/etc
  sudo cp /etc/group $chrootPath/etc
  sudo cp /etc/profile $chrootPath/etc
  sudo cp /etc/shadow $chrootPath/etc
  sudo cp /etc/gshadow $chrootPath/etc
  sudo cp /etc/sudoers $chrootPath/etc
}

function prepareChroot
{
  chrootPath=$1
  set -x
  export DISPLAY=:0
  xhost +local:
  sudo mount --bind $chrootPath $chrootPath
  sudo mount --bind /tmp $chrootPath/tmp
  sudo mount --bind ~/Documents $chrootPath/home/$(whoami)/Documents
  sudo mount --bind /home/$(whoami).old $chrootPath/home/$(whoami)/old
  set +x
}

function restoreChroot
{
  chrootPath=$1
  set -x
  xhost -
  sudo umount $chrootPath
  sudo umount $chrootPath/tmp
  sudo umount $chrootPath/home/$(whoami)/Documents
  sudo umount $chrootPath/home/$(whoami)/old
  set +x
}
