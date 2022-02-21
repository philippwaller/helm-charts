# K3s Traefik Configuration

This Helm Chart allows to override the default [Traefik](https://doc.traefik.io/traefik/) configuration of a [K3s](https://k3s.io) cluster.


## TL;DR

```console
helm repo add philippwaller https://charts.philippwaller.com
helm install custom philippwaller/k3s-traefik-config -n kube-system
```

## Introduction

This charts deploys a HelmChartConfig to overwrite the default [Traefik](https://doc.traefik.io/traefik/) configuration of a [K3s](https://k3s.io) cluster. An additional deployed Kubernetes job copies the manifest file to the bootstrap folder of the "ControlPlane" node. This ensures that the configuration is applied at every restart.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.1+


## Parameters

### Common parameters

| Name               | Description                                        | Value |
| ------------------ | -------------------------------------------------- | ----- |
| `nameOverride`     | String to partially override common.names.fullname | `""`  |
| `fullnameOverride` | String to fully override common.names.fullname     | `""`  |


### Traefik Configuration

| Name            | Description           | Value |
| --------------- | --------------------- | ----- |
| `traefikConfig` | Traefik configuration | `{}`  |


### Docker Image

| Name               | Description                                                                             | Value          |
| ------------------ | --------------------------------------------------------------------------------------- | -------------- |
| `image.repository` | job image repository                                                                    | `alpine`       |
| `image.pullPolicy` | image pull policy                                                                       | `IfNotPresent` |
| `image.tag`        | Overrides the image tag whose default is the chart appVersion.                          | `3.15.0`       |
| `imagePullSecrets` | If defined, uses a Secret to pull an image from a private Docker registry or repository | `[]`           |


### Job Configuration

| Name                 | Description                            | Value |
| -------------------- | -------------------------------------- | ----- |
| `podAnnotations`     | Annotations to be added to the job pod | `{}`  |
| `podSecurityContext` | job pod-level security context         | `{}`  |
| `securityContext`    | Security context                       | `{}`  |
| `resources`          | Resource limits and requests           | `{}`  |
| `nodeSelector`       | Node labels for pod assignment         | `{}`  |
| `tolerations`        | Tolerations for pod assignment         | `[]`  |
| `affinity`           | Affinity for pod assignment            | `{}`  |


### Service Account

| Name                         | Description                                           | Value  |
| ---------------------------- | ----------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account             | `{}`   |
| `serviceAccount.name`        | The name of the service account to use.               | `""`   |


## Support this project
If this project was useful to you in some form, I would be glad to have your support by starring ⭐️ this repository.
