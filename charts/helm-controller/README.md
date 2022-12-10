# Helm Controller

A simple way to manage helm charts (v2 and v3) with Custom Resource Definitions in k8s.


## TL;DR

```console
helm repo add philippwaller https://charts.philippwaller.com
helm install helm-controller philippwaller/helm-controller
```


## Introduction

This chart bootstraps an [Helm Controller](https://github.com/k3s-io/helm-controller) deployment on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.


## Prerequisites

- Kubernetes 1.23+
- Helm 3.1+


## Parameters

### Common parameters

| Name               | Description                                        | Value |
| ------------------ | -------------------------------------------------- | ----- |
| `nameOverride`     | String to partially override common.names.fullname | `""`  |
| `fullnameOverride` | String to fully override common.names.fullname     | `""`  |


### Docker Image

| Name               | Description                                                                             | Value                     |
| ------------------ | --------------------------------------------------------------------------------------- | ------------------------- |
| `image.repository` | Inadyn image repository                                                                 | `rancher/helm-controller` |
| `image.pullPolicy` | image pull policy                                                                       | `IfNotPresent`            |
| `image.tag`        | Overrides the image tag whose default is the chart appVersion.                          | `""`                      |
| `imagePullSecrets` | If defined, uses a Secret to pull an image from a private Docker registry or repository | `[]`                      |


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
