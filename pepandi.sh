echo -e "\033[32m"
echo "################################################################################"
echo "# PePaNDI (Pelican Panel Nginx Docker Image)                                   #"
echo "# by Bliffbot                                                                  #"
echo "# Version 1.0.0                                                                #"
echo "################################################################################"
echo -e "\033[0m"

files=()

for file in $(pwd)/* $(pwd)/.*; do
  files+=$file
done

if [ ${#files[@]} -gt 2 ]; then
  echo -e "\033[33m# The current directory ($(pwd)) is not empty."
  echo "# All files in this directory will be copied into the Docker image."
  echo ""
  echo "# This is okay if you have already downloaded the panel or PePaNDI files."
  echo "# (If you want make your own changes before building the image for example.)"
  echo -e "\033[0m"
fi

read -r -p "# Do you want to download the latest panel files into this directory? [Y/n] " panel

function download_panel () {
  echo ""
  echo -e "\033[3mDownloading Panel files..."
  echo ""
  curl -SL https://github.com/pelican-dev/panel/releases/latest/download/panel.tar.gz | tar -xz
  echo ""
  echo -e "\033[3mDownloading Panel files...\033[32mdone\033[0m"
  echo ""
}

if [ "$panel" = "" ]; then
  panel="Y"
fi

case $panel in
    [Yy]*) echo "# > Yes" ; download_panel ;;
    [Nn]*) echo "# > No" ; echo "" ;;
esac

read -r -p "# Would you like to download the PePaNDI files into this directory? [Y/n] " pepandi

function download_pepandi () {
  echo ""
  echo -e "\033[3mDownloading PePaNDI files..."
  echo ""
  curl -SL https://github.com/bliffbot/PePaNDI/releases/latest/download/pepandi.tar.gz | tar -xz
  echo ""
  echo -e "\033[3mDownloading PePaNDI files...\033[32mdone\033[0m"
  echo ""
}

if [ "$pepandi" = "" ]; then
  pepandi="Y"
fi

case $pepandi in
  [Yy]*) echo "# > Yes" ; download_pepandi ;;
  [Nn]*) echo "# > No" ; echo "" ;;
esac

read -r -p "# Would you like to build the image now? [Y/n] " build

function build_image () {
  echo ""
  read -r -p "# Specify a name and tag for the Docker image (e.g. pepandi:1.0.0): " image
  echo ""
  echo -e "\033[3mBuilding Docker image..."
  echo ""
  docker build -t $image -f "pepandi/Dockerfile" .
  echo ""
  echo -e "\033[3mBuilding Docker image...\033[32mdone\033[0m"
  echo ""
}

if [ "$build" = "" ]; then
  build="Y"
fi

case $build in
  [Yy]*) echo "# > Yes" ; build_image ;;
  [Nn]*) echo "# > No" ; echo "" ;;
esac

echo -e "\033[32mScript finished\033[0m"
echo ""