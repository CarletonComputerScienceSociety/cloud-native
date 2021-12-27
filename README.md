# CCSS Cloud Native

## Ansible

Ansible is used to bootstrap VMs in the SCS OpenStack cluster. It is currently configured to set up Nomad and k3s.

The primary command used to 

## Terraform

Terraform is used to provision external cloud infrastructure, primarily subdomains at the moment.

## Nomad

### Hosted Projects

| Project                                              | Tech Stack                     | cpu/ram   | Links                                                                                                                            |
| ---------------------------------------------------- | ------------------------------ | --------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **Student Projects**                                 |                                |           |                                                                                                                                  |
| [discretemath.ca](https://discretemath.ca/)          | Svelte, Ruby on Rails, GraphQL | 6096/3072 | [Repo](https://github.com/CarletonComputerScienceSociety/discretemath.ca), [Nomad File](nomad/discretemath/no-connect.hcl)       |
| [merged](https://merged.carletoncomputerscience.ca/) | Next.js, Django                | 6096/3072 | [Repo](https://github.com/CarletonComputerScienceSociety/merged), [Nomad File](nomad/merged/merged.nomad)                        |
| FriendZoner                                          | Rust                           | 64/64     | [Repo](https://github.com/CarletonComputerScienceSociety/friend-zoner), [Nomad File](nomad/friend-zoner/friend-zoner.nomad)      |
| Rusty Christmas Tree                                 | Rust                           | 100/30    | [Repo](https://github.com/AngelOnFira/rusty-christmas-tree), [Nomad File](nomad/rusty-christmas-tree/rusty-christmas-tree.nomad) |
| Code Challenge                                       | Svelte, Django                 | 5870/5504 | [Repo](https://github.com/CarletonComputerScienceSociety/code-project), [Nomad File](nomad/code-challenge/code-challenge.nomad)  |
| Prophet Zero                                         | Quasar, Python, Rust           | 6596/3328 | [Repo](https://gitlab.com/GeekWeek/openevents/geekpeek1/team_8_prophet-zero)                                                     |
| Tara Bot                                             | Python                         | 64/64     | [Repo](https://github.com/AlanReviews/Discordpy-bot), [Nomad File](nomad/tara-bot/friend-zoner.nomad)                            |
|                                                      |                                |           |                                                                                                                                  |
| **Services**                                         |                                |           |                                                                                                                                  |
| MinIO                                                |                                | 500/1024  | [Repo](https://github.com/minio/minio), [Nomad File](nomad/minio/minio.hcl)                                                      |
| Cors Anywhere                                        |                                | 50/20     | [Repo](https://github.com/Rob--W/cors-anywhere), [Nomad File](nomad/cors-anywhere/cors-anywhere.hcl)                             |
| ShyNet                                               |                                | 5596/2304 | [Repo](https://github.com/milesmcc/shynet), [Nomad File](nomad/shynet/shynet.nomad)                                              |
| Traefik                                              |                                | 1000/1024 | [Repo](https://github.com/traefik/traefik), [Nomad File](nomad/traefik/traefik.hcl)                                              |
