# stop all containers:
alias docker-kill='docker kill $(docker ps -q)'
# remove all containers
alias docker-rm='docker rm $(docker ps -a -q)'
# remove all docker images
alias docker-rmi='docker rmi -f $(docker images -q)'
# remove all docker volumes
alias docker-rmvol='docker volume ls -qf dangling=true | xargs -r docker volume rm'
# stop & remove all containers/volumes
alias docker-clean='docker-kill || true && docker-rm || true && docker-rmvol || true && docker-rmi'
alias docker-cl='docker-kill || true && docker-rm || true && docker-rmvol'
