# qlik/curl

Simple alpine based docker image with curl binary and SSL dependencies.

## How to build

The Docker image can be built using the following command

```{bash}
docker build -t <your Docker Hub ID>/alpine-curl .
```

where the dot is the current folder, assuming you are running the docker command from the same folder of the Dockerfile.
The image is built with the latest version of curl supported in the alpine version.

## License

This image packages [curl](https://github.com/curl/curl), which is licensed under a [Mixed License](https://curl.haxx.se/legal/licmix.html).
`libcurl` itself is distributed as [MIT License](https://curl.haxx.se/docs/copyright.html).

## Third-Party Licenses

See the git repository for the source code information: https://github.com/qlik-oss/dockerfiles/blob/master/LICENSE

As with all Docker images, these also contain other software which may be under other licenses, along with any direct or indirect dependencies of the primary software being contained.

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

The licenses of the contained software can be determined by inspecting the [Dockerfile](https://github.com/qlik-oss/dockerfiles/blob/master/curl/Dockerfile)

## Unsupported

The source code (Dockerfiles) and binaries (container images) that result are provided for convenience, and not supported in any way.
