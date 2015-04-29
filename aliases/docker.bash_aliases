# general naming scheme
# {namespace}.{object}.{method}.{option}
# namespace == docker
# object == (image,container,server,tarfile,registry)
# method == variations on CRUD (create,read,update,destroy)


alias docker.container.attach='docker attach'
alias docker.container.copy='docker cp'
alias docker.container.delete='docker rm'
alias docker.container.diff='docker diff'
alias docker.container.file.copy=': stub'
alias docker.container.inspect='docker inspect'
alias docker.container.kill='docker kill'
alias docker.container.list='docker ps'
alias docker.container.list.all='docker ps -a'
alias docker.container.logs='docker logs'
alias docker.container.new.image='docker create'
alias docker.container.pause='docker pause'
alias docker.container.port='docker port'
alias docker.container.remove='docker rm'
alias docker.container.restart='docker restart'
alias docker.container.start='docker start'
alias docker.container.stop='docker stop'
alias docker.container.top='docker top'
alias docker.container.unpause='docker unpause'
alias docker.container.wait='docker wait'
alias docker.help='2>&1 docker --help'
alias docker.image.delete='docker rmi'
alias docker.image.history='docker history'
alias docker.image.import='docker import'
alias docker.image.inspect='docker inspect'
alias docker.image.list='docker images'
alias docker.image.list.all='docker.image.list -a'
alias docker.image.new.container='docker commit'
alias docker.image.new.dockerfile='docker build'
alias docker.image.new.registry='docker pull'
alias docker.image.new.tarfile.container='docker import'
alias docker.image.new.tarfile.image='docker load'
alias docker.image.remove='docker rmi'
alias docker.image.tag='docker tag'
alias docker.registry.image.push='docker push'
alias docker.registry.login='docker logout'
alias docker.registry.search='docker search'
alias docker.server.events='docker events'
alias docker.server.info='docker info'
alias docker.server.version='docker version'
alias docker.tarfile.new.image='docker save'
alias docker.tarfile.new.container='docker export'
