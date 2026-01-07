# Platform Kubernetes Kustomize Bases

Base Kustomize templates and Kyverno policies for the In-House GitOps platform.

## Overview

This repository provides standardized, versioned base templates for Kubernetes deployments. Services reference these bases via git URLs to ensure consistent security, resource management, and labeling across all environments.

## Repository Structure

```
in-house-k8s-kustomize-bases/
├── base-deployment/          # Base deployment and service templates
│   ├── deployment.yaml       # Standard deployment with security defaults
│   ├── service.yaml          # Standard ClusterIP service
│   └── kustomization.yaml    # Kustomize configuration
├── policies/kyverno/         # Kyverno policy enforcement
│   ├── resource-limits.yaml  # Require CPU/memory limits
│   ├── required-labels.yaml  # Require standard labels
│   ├── image-pull-policy.yaml# Block :latest tags
│   └── security-baseline.yaml# Security best practices
└── examples/                 # Example service overlays
    └── service-overlay/      # Sample overlay configuration
```

## Features

### Base Deployment Template

The base deployment provides:

- **Security Defaults:**
  - `runAsNonRoot: true`
  - `allowPrivilegeEscalation: false`
  - Drop all capabilities
  - Seccomp profile: RuntimeDefault

- **Resource Management:**
  - Memory: 128Mi request, 256Mi limit
  - CPU: 100m request, 200m limit

- **Health Checks:**
  - Liveness probe on `/health`
  - Readiness probe on `/ready`

- **Standard Labels:**
  - `app`: Application name
  - `team`: Team owner
  - `environment`: Deployment environment (dev/qa/prod)

### Kyverno Policies

Four enforcement policies ensure platform standards:

1. **Resource Limits** - All containers must specify CPU/memory requests and limits
2. **Required Labels** - All pods must have app, team, and environment labels
3. **Image Pull Policy** - Container images must not use `:latest` tag
4. **Security Baseline** - Enforces non-root, no privilege escalation, drop capabilities

## Usage

### Referencing Base Templates

In your service's `kustomization.yaml`, reference this repository:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

# Reference base templates from this repo (versioned)
resources:
  - https://github.com/inhousedotcom/in-house-k8s-kustomize-bases//base-deployment?ref=v1.0.0

# Customize for your service
namespace: my-service

# Replace placeholders
replacements:
  - source:
      kind: Deployment
      fieldPath: metadata.name
    targets:
      - select:
          kind: Service
        fieldPaths:
          - metadata.name

# Patch specific values
patches:
  - target:
      kind: Deployment
    patch: |-
      - op: replace
        path: /metadata/name
        value: my-service
      - op: replace
        path: /spec/template/spec/containers/0/name
        value: my-service
      - op: replace
        path: /spec/template/spec/containers/0/image
        value: myregistry.azurecr.io/my-service:v1.2.3
      - op: replace
        path: /metadata/labels/app
        value: my-service
      - op: replace
        path: /metadata/labels/team
        value: backend-team
      - op: replace
        path: /metadata/labels/environment
        value: dev
```

### Version Pinning

Always reference a specific version tag (not `main` branch):

✅ **Good:**
```yaml
resources:
  - https://github.com/inhousedotcom/in-house-k8s-kustomize-bases//base-deployment?ref=v1.0.0
```

❌ **Bad:**
```yaml
resources:
  - https://github.com/inhousedotcom/in-house-k8s-kustomize-bases//base-deployment  # No version!
```

## Versioning

This repository follows [Semantic Versioning](https://semver.org/):

- **MAJOR** version: Breaking changes (e.g., required field changes)
- **MINOR** version: New features, backwards compatible
- **PATCH** version: Bug fixes, documentation updates

### Current Version: v1.0.0

Initial release with:
- Base deployment and service templates
- MVP Kyverno policies
- Example service overlay

## Deploying Kyverno Policies

Apply policies to your utility cluster:

```bash
kubectl apply -k https://github.com/inhousedotcom/in-house-k8s-kustomize-bases//policies/kyverno?ref=v1.0.0
```

Verify policies are active:

```bash
kubectl get clusterpolicies
```

## Testing Your Overlay

Build your service's Kustomize overlay locally:

```bash
cd your-service/k8s/overlays/dev
kustomize build .
```

Apply to cluster:

```bash
kustomize build . | kubectl apply -f -
```

## Contributing

This repository is maintained by the Platform Engineering team. To propose changes:

1. Create a feature branch
2. Make changes and test thoroughly
3. Submit PR with clear description
4. Platform team will review and merge
5. New version will be tagged

## Support

- **Documentation:** See `examples/service-overlay/` for complete example
- **Issues:** Open GitHub issue in this repository
- **Questions:** #platform-engineering Slack channel

## License

Internal use only - In-House Platform Engineering Team
