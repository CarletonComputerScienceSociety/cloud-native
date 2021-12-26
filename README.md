# CCSS Cloud Native

## Ansible

Ansible is used to bootstrap VMs in the SCS OpenStack cluster. It is currently configured to set up Nomad and k3s.

The primary command used to 

## Terraform

Terraform is used to provision external cloud infrastructure, primarily subdomains at the moment.

## Nomad

### Hosted Projects

| Project              	| Repo                                                                                                                	| Nomad File                                                                                                     	| Tech Stack                     	|
|----------------------	|---------------------------------------------------------------------------------------------------------------------	|----------------------------------------------------------------------------------------------------------------	|--------------------------------	|
| **Student Projects** 	|                                                                                                                     	|                                                                                                                	|                                	|
| discretemath.ca      	| [CarletonComputerScienceSociety/discretemath.ca](https://github.com/CarletonComputerScienceSociety/discretemath.ca) 	| [nomad/discretemat/no-connect.hcl](nomad/discretemath/no-connect.hcl)                                          	| Svelte, Ruby on Rails, GraphQL 	|
| merged               	| [CarletonComputerScienceSociety/megerd](https://github.com/CarletonComputerScienceSociety/merged)                   	| [nomad/merged/merged.nomad](nomad/merged/merged.nomad)                                                         	| Next.js, Django                	|
| FriendZoner          	| [CarletonComputerScienceSociety/friend-zoner](https://github.com/CarletonComputerScienceSociety/friend-zoner)       	| [nomad/friend-zoner/friend-zoner.nomad](nomad/friend-zoner/friend-zoner.nomad)                                 	| Rust                           	|
| Rusty Christmas Tree 	| [AngelOnFira/rusty-christmas-tree](https://github.com/AngelOnFira/rusty-christmas-tree)                             	| [nomad/rusty-christmas-tree/rusty-christmas-tree.nomad](nomad/rusty-christmas-tree/rusty-christmas-tree.nomad) 	| Rust                           	|
| Code Challenge       	| [CarletonComputerScienceSociety/code-project](https://github.com/CarletonComputerScienceSociety/code-project)       	| [nomad/code-challenge/code-challenge.nomad](nomad/code-challenge/code-challenge.nomad)                         	| Svelte                         	|
| Prophet Zero         	| (gitlab.com/geekpeek1/team_8_prophet-zero)[https://gitlab.com/GeekWeek/openevents/geekpeek1/team_8_prophet-zero]    	|                                                                                                                	| Quasar, Python, Rust           	|
|                      	|                                                                                                                     	|                                                                                                                	|                                	|
| **Services**         	|                                                                                                                     	|                                                                                                                	|                                	|
| MinIO                	| [minio/minio](https://github.com/minio/minio)                                                                       	| [nomad/minio/minio.hcl](nomad/minio/minio.hcl)                                                                 	|                                	|
| Cors Anywhere        	| [Rob--W/cors-anywhere](https://github.com/Rob--W/cors-anywhere)                                                     	| [nomad/cors-anywhere/cors-anywhere.hcl](nomad/cors-anywhere/cors-anywhere.hcl)                                 	|                                	|
| ShyNet               	| [milesmcc/shynet](https://github.com/milesmcc/shynet)                                                               	| [nomad/shynet/shynet.nomad](nomad/shynet/shynet.nomad)                                                         	|                                	|
| Traefik              	| [traefik/traefik](https://github.com/traefik/traefik)                                                               	| [nomad/traefik/traefik.hcl](nomad/traefik/traefik.hcl)                                                         	|                                	|
