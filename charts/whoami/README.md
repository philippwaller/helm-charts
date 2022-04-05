# Whoami

Tiny Go webserver that prints os information and HTTP request to output


## TL;DR

```console
helm repo add philippwaller https://charts.philippwaller.com
helm install whoami philippwaller/whoami
```


## Introduction

This chart bootstraps an [whoami](https://github.com/traefik/whoami) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.


## Prerequisites

- Kubernetes 1.15+
- Helm 3.1+


## Parameters

### Common parameters

| Name               | Description                                        | Value    |
| ------------------ | -------------------------------------------------- | -------- |
| `nameOverride`     | String to partially override common.names.fullname | `whoami` |
| `fullnameOverride` | String to fully override common.names.fullname     | `""`     |


### Docker Image

| Name               | Description                                                                             | Value            |
| ------------------ | --------------------------------------------------------------------------------------- | ---------------- |
| `image.repository` | whoami image repository                                                                 | `traefik/whoami` |
| `image.pullPolicy` | image pull policy                                                                       | `IfNotPresent`   |
| `image.tag`        | Overrides the image tag whose default is the chart appVersion.                          | `""`             |
| `imagePullSecrets` | If defined, uses a Secret to pull an image from a private Docker registry or repository | `[]`             |


### Container Configuration

| Name                                         | Description                                 | Value   |
| -------------------------------------------- | ------------------------------------------- | ------- |
| `replicaCount`                               | The number of pods to run                   | `1`     |
| `autoscaling.enabled`                        | Enable replica autoscaling depending on CPU | `false` |
| `autoscaling.minReplicas`                    | Minimum number of replicas                  | `1`     |
| `autoscaling.maxReplicas`                    | Maximum number of replicas                  | `100`   |
| `autoscaling.targetCPUUtilizationPercentage` | CPU utilization threshold                   | `80`    |
| `podAnnotations`                             | Annotations to be added to the pod          | `{}`    |
| `podSecurityContext`                         | Pod-level security context                  | `{}`    |
| `securityContext`                            | Security context                            | `{}`    |
| `resources`                                  | Resource and requests limits                | `{}`    |
| `nodeSelector`                               | Node labels for pod assignment              | `{}`    |
| `tolerations`                                | Tolerations for pod assignment              | `[]`    |
| `affinity`                                   | Affinity for pod assignment                 | `{}`    |


### Service Account

| Name                         | Description                                           | Value  |
| ---------------------------- | ----------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account             | `{}`   |
| `serviceAccount.name`        | The name of the service account to use.               | `""`   |


### Service Configuration

| Name                  | Description                                                                 | Value       |
| --------------------- | --------------------------------------------------------------------------- | ----------- |
| `service.type`        | Service type                                                                | `ClusterIP` |
| `service.port`        | Port of the internal Kubernetes service                                     | `80`        |
| `ingress.enabled`     | Enable ingress record generation                                            | `false`     |
| `ingress.className`   | IngressClass that will be be used to implement the Ingress                  | `""`        |
| `ingress.annotations` | Additional annotations for the Ingress resource.                            | `{}`        |
| `ingress.hosts`       | An array with ingress host objects, under which service should be reachable | `{}`        |
| `ingress.tls`         | An array of TLS configurations                                              | `[]`        |


## Support this project
If this project was useful to you in some form, I would be glad to have your support by starring ⭐️ this repository.
