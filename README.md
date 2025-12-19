# SE Demo Monorepo

This repo houses any custom apps uses by Akuity teams in customer demos.

## Directories

### `templated`

This is a special directory linked to platform team controller kargo workflows and k8s manifests. See [templated readme](/templated/README.md) for more information.

### `rollouts-app`

This application controls it's own k8s manifests, and is used by a few demo projects.

- Rollouts Demo - the self-named demo features progressive delviery and PR based approvals. 
  - [kargo definition](https://github.com/akuity/sedemo-platform/tree/main/kargo/kargo-custom/rollouts-app)
- Local Shard w/ ESO - this demo uses a local Kargo Shard to take advantage of External Secrets Operator, and includes Jira based approvals
  - [kargo definition](https://github.com/akuity/sedemo-platform/tree/main/kargo/kargo-custom/local-shard-eso)