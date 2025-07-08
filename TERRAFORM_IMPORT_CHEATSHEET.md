# Terraform Import Cheat Sheet

## The Nested Module Madness

### Understanding Terraform Module Structure
```
terraform/
├── main.tf              # Root module
├── modules/
│   └── infra/
│       ├── main.tf      # Infra module
│       └── istio/
│           ├── main.tf  # Istio module
│           └── gateway/
│               └── main.tf  # Gateway submodule
```

### Resource Address Syntax
```bash
# Root module resource
terraform import aws_instance.example i-1234567890abcdef0

# Single level module
terraform import module.network.aws_vpc.main vpc-12345

# Nested modules (THE MADNESS!)
terraform import module.infra.module.istio.module.gateway.helm_release.istio_ingress istio-ingress/istio-ingress
```

## Terraform Import Command Syntax

### Basic Structure
```bash
terraform import [options] RESOURCE_ADDRESS RESOURCE_ID
```

### Common Resource Types and IDs

#### Helm Releases
```bash
# Format: namespace/release-name
terraform import module.infra.module.istio.module.gateway.helm_release.istio_ingress istio-ingress/istio-ingress
terraform import module.infra.module.postgres.helm_release.postgresql default/postgresql
```

#### Kubernetes Resources
```bash
# Namespaces (just the namespace name)
terraform import kubernetes_namespace.istio_system istio-system
terraform import module.infra.module.istio.module.gateway.kubernetes_namespace.istio_ingress istio-ingress

# Services (namespace/service-name)
terraform import kubernetes_service.example default/my-service

# ConfigMaps (namespace/configmap-name)
terraform import kubernetes_config_map.example default/my-configmap
```

#### AWS Resources
```bash
# EC2 Instances
terraform import aws_instance.example i-1234567890abcdef0

# VPC
terraform import aws_vpc.example vpc-12345
```

## Inspecting Terraform State

### 1. List All Resources
```bash
terraform state list
```

### 2. Show Resource Details
```bash
terraform state show RESOURCE_ADDRESS
```

### 3. Find Resource Address
```bash
# Search for specific resource
terraform state list | grep istio
terraform state list | grep postgres
```

### 4. Inspect Module Structure
```bash
# See all resources in a module
terraform state list | grep "module.infra"
terraform state list | grep "module.infra.module.istio"
```

## Decoding Resource Addresses

### Pattern Recognition
```
module.MODULE_NAME.module.SUBMODULE.RESOURCE_TYPE.RESOURCE_NAME
```

### Examples from Your Codebase
```bash
# Istio base components
module.infra.module.istio.module.base.kubernetes_namespace.istio_system
module.infra.module.istio.module.base.helm_release.istio_base

# Istio control plane
module.infra.module.istio.module.istiod.helm_release.istiod

# Istio gateway
module.infra.module.istio.module.gateway.kubernetes_namespace.istio_ingress
module.infra.module.istio.module.gateway.helm_release.istio_ingress

# PostgreSQL
module.infra.module.postgres.helm_release.postgresql
module.infra.module.postgres.kubernetes_config_map.postgres_init
```

## Common Import Scenarios

### 1. Manually Created Helm Release
```bash
# Check what exists
helm list -A

# Import into Terraform
terraform import module.infra.module.istio.module.gateway.helm_release.istio_ingress istio-ingress/istio-ingress
```

### 2. Manually Created Kubernetes Resource
```bash
# Check what exists
kubectl get namespaces
kubectl get services -A

# Import namespace
terraform import kubernetes_namespace.example my-namespace

# Import service
terraform import kubernetes_service.example my-namespace/my-service
```

### 3. The "Namespace Already Exists" Problem
```bash
# Problem: You get this error during terraform apply
Error: namespaces "istio-ingress" already exists

# Solution: Import the existing namespace first
terraform import module.infra.module.istio.module.gateway.kubernetes_namespace.istio_ingress istio-ingress

# Then apply normally
terraform apply
```

### 4. Before Import Checklist
1. **Create the resource configuration** in Terraform first
2. **Find the correct resource address** using `terraform state list`
3. **Get the resource ID** from the actual infrastructure
4. **Run the import command**
5. **Run `terraform plan`** to see if configuration matches

## Troubleshooting Import Issues

### Error: Resource doesn't exist in configuration
```bash
# Error you got
Error: resource address "module.infra.module.istio.helm_release.istio_ingress" does not exist

# Solution: Check actual structure
terraform state list | grep istio
# Shows: module.infra.module.istio.module.gateway.helm_release.istio_ingress
```

### Error: Resource already managed
```bash
# Check if already imported
terraform state list | grep RESOURCE_NAME

# Remove from state if needed
terraform state rm RESOURCE_ADDRESS
```

### Error: Invalid resource ID
```bash
# For Helm releases, check format
helm list -A
# Use: namespace/release-name

# For Kubernetes resources, check format  
kubectl get RESOURCE -o yaml
# Use appropriate ID format
```

## Useful Commands

### State Management
```bash
# Backup state before importing
cp terraform.tfstate terraform.tfstate.backup

# Remove resource from state
terraform state rm RESOURCE_ADDRESS

# Move resource to different address
terraform state mv OLD_ADDRESS NEW_ADDRESS

# Refresh state
terraform refresh
```

### Planning and Validation
```bash
# See what would change
terraform plan

# Validate configuration
terraform validate

# Show current state
terraform show
```

## Pro Tips

1. **Always run `terraform plan`** after import to verify configuration matches
2. **Use `terraform state list`** to find exact resource addresses
3. **Check nested module structure** in your `.tf` files
4. **Back up state** before major import operations
5. **Import one resource at a time** to avoid confusion
6. **Use `helm list -A`** and `kubectl get` to find resource IDs
7. **The module path in import must match your module structure exactly**

## Quick Reference

### Find Resource Address
```bash
terraform state list | grep SEARCH_TERM
```

### Import Template
```bash
terraform import MODULE_PATH.RESOURCE_TYPE.RESOURCE_NAME RESOURCE_ID
```

### Verify Import
```bash
terraform plan
terraform state show RESOURCE_ADDRESS
```