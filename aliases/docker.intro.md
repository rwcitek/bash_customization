
# Introduction: a brief skim

Docker uses a model that is similar to EC2 with four basic structures: 

- images
- containers
- a service
- repository

There are two other objects that are ancillary to Docker itself:

- tar files
- dockerfiles

Images are analogous to Amazon images (AMI's).  Containers are analogous to instances.  The Docker server is similar to the Amazon console: through it, one manages the containers.  The local repository stores local images and caches images from Docker Hub, which is like Amazon's image Marketplace.  Each of those structures have associated commands and properties.

Just like Amazon AMI's, images are created, queried, modified, and removed. Images can be created in a number of ways:

- pulled from a repository ('docker pull')
- built from a Dockerfile file ('docker build')
- committed from a container ('docker commit')
- imported from a tar file that was generated from a container or another image ('docker save/load/import/export')

## Images

You can list the images in the local repository with 'docker images'.  Add the --help option to get info on all the options, which are used to filter the list of images and how it is displayed.

Image properties can be viewed with 'docker inspect' and 'docker history'.

Images can have their associated tags changed, but little else. Tags are labels that provide a convenient short-hand when referring to an image.

Images can be removed with 'docker rmi' but only after any associated container instances have been deleted ('docker rm -v'). 

## Containers

Container instances (containers, for short) are created, queried, modified, and deleted much like images. They also can exist in three states: running, stopped, or paused.  All containers are created from images ('docker run' or 'docker create').

You can list the current instances ('docker ps' for running instances. 'docker ps -a' for all instances)

Like images, you can view instance properties with 'docker inspect'

You can change the instance state using 'docker kill/stop/start/pause/unpause'

Once stopped, instances can be remove with 'docker delete -v'


## Docker service


## Repository and Docker Hub


## Ancilary files: tarfiles and Dockerfiles


# Docker aliases

Unfortunately, the Docker commands do not effectively reflect the structure of the Docker model.  In addition, the Docker documentation uses the term "container" for both container images and container instances.  To help me remember the Docker objects and operations that work on them, I have created a collection of aliases all beginning with the label "docker."


