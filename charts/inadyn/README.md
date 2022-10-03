# Inadyn - Internet Automated Dynamic DNS Client

[Inadyn](https://github.com/troglobit/inadyn) , or In-a-Dyn, is a small and simple Dynamic DNS, DDNS, client with HTTPS support. Commonly available in many GNU/Linux distributions, used in off the shelf routers and Internet gateways to automate the task of keeping your Internet name in sync with your public¹ IP address. It can also be used in installations with redundant (backup) connections to the Internet.


## TL;DR

```console
helm repo add philippwaller https://charts.philippwaller.com
helm install inadyn philippwaller/inadyn
```


## Introduction

This chart bootstraps an [Inadyn](https://github.com/troglobit/inadyn) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.


## Prerequisites

- Kubernetes 1.22+
- Helm 3.1+


## Parameters

### Common parameters

| Name               | Description                                        | Value    |
| ------------------ | -------------------------------------------------- | -------- |
| `nameOverride`     | String to partially override common.names.fullname | `inadyn` |
| `fullnameOverride` | String to fully override common.names.fullname     | `""`     |


### Inadyn Configuration

| Name           | Description                                                                                                  | Value |
| -------------- | ------------------------------------------------------------------------------------------------------------ | ----- |
| `inadynConfig` | Content of the inadyn configuration file ([inadyn.conf](https://fossies.org/linux/inadyn/man/inadyn.conf.5)) | `""`  |


### Docker Image

| Name               | Description                                                                             | Value              |
| ------------------ | --------------------------------------------------------------------------------------- | ------------------ |
| `image.repository` | Inadyn image repository                                                                 | `troglobit/inadyn` |
| `image.pullPolicy` | image pull policy                                                                       | `IfNotPresent`     |
| `image.tag`        | Overrides the image tag whose default is the chart appVersion.                          | `""`               |
| `imagePullSecrets` | If defined, uses a Secret to pull an image from a private Docker registry or repository | `[]`               |


### Container Configuration

| Name                 | Description                               | Value |
| -------------------- | ----------------------------------------- | ----- |
| `replicaCount`       | The number of pods to run                 | `1`   |
| `podAnnotations`     | Annotations to be added to the inadyn pod | `{}`  |
| `podSecurityContext` | Inadyn pod-level security context         | `{}`  |
| `securityContext`    | Security context                          | `{}`  |
| `resources`          | Resource limits and requests for inadyn   | `{}`  |
| `nodeSelector`       | Node labels for pod assignment            | `{}`  |
| `tolerations`        | Tolerations for pod assignment            | `[]`  |
| `affinity`           | Affinity for pod assignment               | `{}`  |


### Service Account

| Name                         | Description                                           | Value  |
| ---------------------------- | ----------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account             | `{}`   |
| `serviceAccount.name`        | The name of the service account to use.               | `""`   |


## Support this project
If this project was useful to you in some form, I would be glad to have your support by starring ⭐️ this repository.
