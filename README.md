
## Repositories
- [Docker Hub repository](https://registry.hub.docker.com/u/kalaksi/ossec-log-server/)
- [GitHub repository](https://github.com/kalaksi/docker-ossec-log-server)

## What is this container for?
This container is for running OSSEC HIDS log analysis server and optionally sending alerts via email. It accepts syslog-formatted logs. One use case is a centralized log archiving and analysis server for your containers. I currently use this container and [Logspout](https://github.com/gliderlabs/logspout) to achieve this.


## Why use this container?
**Simply put, this container has been written with simplicity and security in mind.**

Surprisingly, _many_ community containers run unnecessarily with root privileges by default and don't provide help for dropping unneeded CAPabilities either.
Additionally, overly complex shell scripts and unofficial base images make it harder to verify the source and keep everything up-to-date.  

To remedy the situation, these images have been written with security and simplicity in mind. See [Design Goals](#design-goals) further down.

|Requirement              |Status|Details|
|-------------------------|:----:|-------|
|Don't run as root        |❌    | Difficult to get around. Currently ossec-control drops the privileges.|
|Official base image      |✅    | |
|Drop extra CAPabilities  |❌    | TODO: test what can be dropped |
|Handle signals properly  |✅    | |
|Versioned tags           |✅    | |
|Minimal                  |✅    | |

### Supported tags
See the ```Tags``` tab on Docker Hub for specifics. Basically you have:
- The default ```latest``` tag that always has the latest changes.
- Minor versioned tags (follow Semantic Versioning), e.g. ```1.1``` which would follow branch ```1.1.x``` on GitHub.

### Configuration
See ```Dockerfile``` and ```docker-compose.yml``` (<https://github.com/kalaksi/docker-ossec-log-server>) for usable environment variables. Variables that are left empty will use default values.  

### Upgrading to a new version
As OSSEC gets upgraded to a more recent version, your will face the common issue of configurations getting outdated.  
In that case, you can try to resolve the configuration issues yourself and update the configuration OR move aside both ```etc``` and ```rules``` directories on your data-volume so that OSSEC will then create a new default configuration. After that, you can bring over any manual changes you might have done. 

## Development
### TODO 
- Get around ```ossec-contol``` and run the necessary processes directly. Helps running things as non-root and for detecting crashes.
- Test and document ways to add custom configuration.

### Design Goals
- Never run as root unless necessary.
- Use only official base images.
- Provide an example ```docker-compose.yml``` that also shows what CAPabilities can be dropped.
- Offer versioned tags for stability.
- Simple and minimal: try to keep everything in the Dockerfile if reasonable.
- Don't restrict configuration possibilities: provide a way to use native config files for the containerized application.
- Handle signals properly.

### Contributing
See the repository on <https://github.com/kalaksi/docker-ossec-log-server>.
All kinds of contributions are welcome!

## License
View [license information](https://github.com/kalaksi/docker-ossec-log-server/blob/master/LICENSE) for the software contained in this image.  
As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).  
  
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
