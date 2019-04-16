# qlik/gradle

> ⚠️ _WARNING:_ This image is deprecated and unsupported. Please switch to another image like [the official `gradle` image](https://hub.docker.com/_/gradle).

A Java development image with Gradle installed.

## How to build

The Docker image can be built using the following command

```{bash}
docker build -t <your Docker Hub ID>/gradle .
```

where the dot is the current folder, assuming you are running the docker command from the same folder of the Dockerfile.
If you want a specific Gradle version, build the image with this command instead:

```{bash}
docker build -t <your Docker Hub ID>/gradle --build-arg GRADLE_VERSION=<Gradle version> .
```

## License

This image packages [Gradle](https://github.com/gradle/gradle), which is licensed under the [Apache 2.0](http://www.apache.org/licenses/LICENSE-2.0) license.

## Third-Party Licenses

See the git repository for the source code information: https://github.com/qlik-oss/dockerfiles/blob/master/LICENSE

As with all Docker images, these also contain other software which may be under other licenses, along with any direct or indirect dependencies of the primary software being contained.

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

The licenses of the contained software can be determined by inspecting the [Dockerfile](https://github.com/qlik-oss/dockerfiles/blob/master/gradle/Dockerfile)

## Unsupported

The source code (Dockerfiles) and binaries (container images) that result are provided for convenience, and not supported in any way.
