# PePaNDI - (Pelican Panel Nginx Docker Image)
## Why
I have been having some trouble with the Docker Image for the Pelican panel when it comes to multi-domain-support. Using nginx as the webserver has fixed these issues for me and I also think that the panel has become more responsive.

## Content
This repo contains a script that gets all needed files like the modified Dockerfile and uses them to build a new Docker image. I have also made some QOL improvements, one example is that the `.env`-file contains now more (all that I know of) options. All the changed files will be downloaded into the `pepandi` folder so you can exit the script and make all the changes you want before building the Docker image.

Another config file that I had to change is the nginx config where I had to add: `add_header Access-Control-Allow-Origin "*" always;` as I need it when using multiple domains. But if you dont need that then I would recommend that you remove this line as it does make the panel less secure.

## Usage
Run the following command in an empty folder to execute the script I made which will run you through the setup.
```shell
bash <(curl -sSL https://github.com/bliffbot/PePaNDI/releases/latest/pepandi.sh)
```

**Notes**
1. The PePaNDI image allows you to access all of the panel files when using a docker volume bind to `/pelican-data`.
2. The Dockerfile for the Pelican panel is creating some resources in a temporary image which will be copied into the final image. Due to this functionality it is (probably) not possible to use the default upgrade process described in the Pelican Docs. This means that you will need to build a new image if you want to update the panel. This can easily be done with the script while keeping your modifications.

## Compatibility
| PePaNDI Version | Pelican Panel Version |
|-----------------|-----------------------|
| 1.0.0           | v1.0.0-beta13         |