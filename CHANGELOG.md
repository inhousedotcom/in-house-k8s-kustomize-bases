# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.0.0] - Unreleased

### Added
- Initial release of base Kustomize templates
- Base deployment template with security defaults
- Base service template (ClusterIP)
- Kyverno policies for platform enforcement:
  - Resource limits policy
  - Required labels policy
  - Image pull policy (no :latest tags)
  - Security baseline policy
- Example service overlay
- Comprehensive README documentation
- Automated release workflow based on CHANGELOG
- PR validation workflow requiring CHANGELOG updates
- Template validation workflow

### Security
- runAsNonRoot enforced
- allowPrivilegeEscalation: false
- Drop all capabilities
- Seccomp profile: RuntimeDefault

[v1.0.0]: https://github.com/inhousedotcom/in-house-k8s-kustomize-bases/releases/tag/v1.0.0
