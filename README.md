
### Repositories
- [Docker Hub repository](https://registry.hub.docker.com/u/kalaksi/ossec-log-server/)
- [GitHub repository](https://github.com/kalaksi/docker-ossec-log-server)

### What is this container for?
This container is for running OSSEC HIDS log analysis server and optionally sending alerts via email. It accepts syslog-formatted logs.  
One use case is a centralized log archiving and analysis server for your containers (using e.g. Logspout).  

** Note: while fully functional and working, this container is still waiting these features to be implemented:  **
- Getting around ```ossec-contol``` and running the necessary process directly, which would help detecting if the process crashes.  
- Dropping root privileges before executing (currently, ```ossec-control``` drops the privileges).
- Test which capabilities can be dropped
- Test and document ways to add custom configuration.

### Why use this container?
**Simply put, this container has been written with simplicity and security in mind.**

Surprisingly, _many_ community containers run unnecessarily with root privileges by default and don't provide help for dropping unneeded CAPabilities either.
Additionally, overly complex shell scripts and unofficial base images make it harder to verify the source.  

To remedy the situation, these images have been written with security and simplicity in mind. See [Design Goals](#design-goals) further down.

### Running this container
At the moment, I'm not providing full commands here.  
I assume you're experienced enough to know how to run containers.  

#### Supported tags
See the ```Tags``` tab on Docker Hub for specifics. Basically you have:
- The default ```latest``` tag that always has the latest changes.
- Minor versioned tags (follow Semantic Versioning), e.g. ```1.1``` which would follow branch ```1.1.x``` on GitHub.

#### Configuration
See ```Dockerfile``` and ```docker-compose.yml``` (<https://github.com/kalaksi/docker-ossec-log-server>) for usable environment variables. Variables that are left empty will use default values.  

#### Upgrading to a new version
As OSSEC gets upgraded to a more recent version, your will face the common issue of configurations getting outdated.  
In that case, you can try to resolve the configuration issues yourself and update the configuration OR move aside both ```etc``` and ```rules``` directories on your data-volume so that OSSEC will then create a new default configuration. After that, you can bring over any manual changes you might have done. 

### Development
#### Design Goals
- Never run as root unless necessary.
- Use only official base images.
- Provide an example ```docker-compose.yml``` that also shows what CAPabilities can be dropped.
- Offer versioned tags for stability.
- Try to keep everything in the Dockerfile (if reasonable, considering line count and readability).
- Don't restrict configuration possibilities: provide a way to use native config files for the containerized application.
- Handle signals properly.

#### Contributing
See the repository on <https://github.com/kalaksi/docker-ossec-log-server>.
All kinds of contributions are welcome!

### License
View [license information](https://github.com/kalaksi/docker-ossec-log-server/blob/master/LICENSE) for the software contained in this image.  
As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).  
  
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.
