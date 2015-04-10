Docker uses a model that is similar to EC2 with four basic structures: images, containers, a service, and a repository. Images are analogous to Amazon images (AMI's). Containers are analogous to instances.  The Docker server is similar to the Amazon console.  And the Docker Hub is like Amazon's image Marketplace.  Each of those structures have associated commands and properties.

Unfortunately, the Docker commands confuse me as they do not effectively reflect the structure of the Docker model.  In addition, the Docker documentation uses the term "container" for both container images and container instances.

Just like Amazon AMI's, images are created, queried, modified, and removed. Images can be created in a number of ways:

- pulled from a repository (docker pull)
- built from a Dockerfile file (docker build)
- committed from a container (docker commit)
- imported from a tar file that was generated from a container or another image (docker save/load/import/export)

You can list the images you have with 'docker images'.  Add the --help option to get info on all the options, which are used to filter the list of images and how it is displayed.

Image properties can be viewed with 'docker inspect' and 'docker history'.

Images can have their associated tags changed, but little else. Tags are labels that provide a convenient short-hand when referring to an image.

Images can be removed with 'docker rmi' but only after any associated container instances have been deleted. 

Container instances (containers, for short) are created, queried, modified, and deleted much like images. They also can exist in three states: running, stopped, or paused.  All containers are created from images and are in the stopped state, initially.














