# CCSS Cloud Native

## Ansible

Ansible is used to bootstrap VMs in the SCS OpenStack cluster. It is currently configured to set up Nomad and k3s.

The primary command used to 

## Terraform

Terraform is used to provision external cloud infrastructure, primarily subdomains at the moment.

## Nomad

### Hosted Projects

| Project              	| Tech Stack                     	| Repo                                                                              	| Nomad File                                                         	|
|----------------------	|--------------------------------	|-----------------------------------------------------------------------------------	|--------------------------------------------------------------------	|
| **Student Projects** 	|                                	|                                                                                   	|                                                                    	|
| discretemath.ca      	| Svelte, Ruby on Rails, GraphQL 	| [Repo Link](https://github.com/CarletonComputerScienceSociety/discretemath.ca)    	| [File Link](nomad/discretemath/no-connect.hcl)                     	|
| merged               	| Next.js, Django                	| [Repo Link](https://github.com/CarletonComputerScienceSociety/merged)             	| [File Link](nomad/merged/merged.nomad)                             	|
| FriendZoner          	| Rust                           	| [Repo Link](https://github.com/CarletonComputerScienceSociety/friend-zoner)       	| [File Link](nomad/friend-zoner/friend-zoner.nomad)                 	|
| Rusty Christmas Tree 	| Rust                           	| [Repo Link](https://github.com/AngelOnFira/rusty-christmas-tree)                  	| [File Link](nomad/rusty-christmas-tree/rusty-christmas-tree.nomad) 	|
| Code Challenge       	| Svelte                         	| [Repo Link](https://github.com/CarletonComputerScienceSociety/code-project)       	| [File Link](nomad/code-challenge/code-challenge.nomad)             	|
| Prophet Zero         	| Quasar, Python, Rust           	| [Repo Link](https://gitlab.com/GeekWeek/openevents/geekpeek1/team_8_prophet-zero) 	|                                                                    	|
| Tara Bot             	| Python                         	| [Repo Link](https://github.com/AlanReviews/Discordpy-bot)                         	| [File Link](nomad/tara-bot/friend-zoner.nomad)                     	|
|                      	|                                	|                                                                                   	|                                                                    	|
| **Services**         	|                                	|                                                                                   	|                                                                    	|
| MinIO                	|                                	| [Repo Link](https://github.com/minio/minio)                                       	| [File Link](nomad/minio/minio.hcl)                                 	|
| Cors Anywhere        	|                                	| [Repo Link](https://github.com/Rob--W/cors-anywhere)                              	| [File Link](nomad/cors-anywhere/cors-anywhere.hcl)                 	|
| ShyNet               	|                                	| [Repo Link](https://github.com/milesmcc/shynet)                                   	| [File Link](nomad/shynet/shynet.nomad)                             	|
| Traefik              	|                                	| [Repo Link](https://github.com/traefik/traefik)                                   	| [File Link](nomad/traefik/traefik.hcl)                             	|
