# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

```
docker-compose up --build
docker-compose exec webapi rails db:migrate
docker-compose exec webapi rake jobs:work
docker-compose exec webapi rake jobs:clear ->  #Elimina todos los jobs
docker-compose exec webapi rails c
tmux
```
List all containers (only IDs) docker ps -aq.
Stop all running containers. docker stop $(docker ps -aq)
Remove all containers. docker rm $(docker ps -aq)
Remove all images. docker rmi $(docker images -q)

List all containers (only IDs)sudo docker ps -aq.
Stop all running containers.sudo docker stop $(sudo docker ps -aq)
Remove all containers.sudo docker rm $(sudo docker ps -aq)
Remove all images.sudo docker rmi $sudo (docker images -q)

tmux new-window
tmux swap-window -t 1

split tmux
Ctrl + Shift + b + %
Ctrl + Shift + b + "

