# Terraform State Recovery Guide

## The Problem: Interrupted Terraform Apply

When you `Ctrl-C` during `terraform apply`, you end up with:
- **Partial deployments** in the cluster
- **Inconsistent state** - Terraform doesn't know about partial resources
- **"Resource already exists" errors** on next apply

## Golden Rule: NEVER Ctrl-C During Apply

**Instead, let Terraform finish and handle errors gracefully.**

But if you already did it, here's how to recover:

## Recovery Steps

### 1. Assess the Damage
```bash
# Check Terraform state
terraform state list

# Check what's actually in the cluster
kubectl get all -A
helm list -A
```

### 2. Find Orphaned Resources
```bash
# Compare what Terraform thinks exists vs reality
terraform plan

# Look for resources that exist in cluster but not in state
kubectl get deployments,services,configmaps -A
```

### 3. Recovery Options

#### Option A: Import Existing Resources (Recommended)
```bash
# For each resource that exists but isn't in state
terraform import module.apps.kubernetes_deployment.server default/server
terraform import module.apps.kubernetes_service.server_service default/server-service
```

#### Option B: Delete and Recreate
```bash
# Delete the partial deployment
kubectl delete deployment server -n default
kubectl delete service server-service -n default

# Then apply fresh
terraform apply
```

#### Option C: Manual State Surgery (Dangerous)
```bash
# Remove from state file
terraform state rm module.apps.kubernetes_deployment.server

# Then apply
terraform apply
```

## Prevention: Proper Error Handling

### Instead of Ctrl-C, Do This:

1. **Let Terraform finish** - it will show you all errors
2. **Read the error messages** - they often tell you exactly what's wrong
3. **Fix the configuration** - update your .tf files
4. **Run apply again** - Terraform will only create what's missing

### Example Error Flow:
```bash
# Terraform fails to create deployment
terraform apply
# Error: deployment "server" failed: image pull error

# DON'T Ctrl-C! Let it finish showing all errors
# Fix the image name in terraform.tfvars
server_image = "quote-server:v1.0"

# Apply again - Terraform will retry only failed resources
terraform apply
```

## Common Scenarios and Solutions

### 1. Helm Release "Name Already in Use"
```bash
# Check existing releases
helm list -A

# Option 1: Import
terraform import module.infra.module.postgres.helm_release.postgresql default/postgresql

# Option 2: Uninstall and retry
helm uninstall postgresql -n default
terraform apply
```

### 2. Kubernetes Deployment "Already Exists"
```bash
# Check existing deployments
kubectl get deployments -A

# Option 1: Import
terraform import module.apps.kubernetes_deployment.server default/server

# Option 2: Delete and retry
kubectl delete deployment server -n default
terraform apply
```

### 3. Namespace "Already Exists"
```bash
# Import the namespace
terraform import module.infra.module.istio.module.gateway.kubernetes_namespace.istio_ingress istio-ingress

# Then apply
terraform apply
```

## State File Safety

### Always Backup Before Surgery
```bash
# Backup current state
cp terraform.tfstate terraform.tfstate.backup

# If you mess up, restore
cp terraform.tfstate.backup terraform.tfstate
```

### Use Remote State for Teams
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "observability-stack/terraform.tfstate"
    region = "us-west-2"
  }
}
```

## When Things Go Really Wrong

### Nuclear Option: Full Reset
```bash
# Delete everything in cluster
kubectl delete namespace default --force
kubectl delete namespace istio-system --force
kubectl delete namespace istio-ingress --force

# Delete state file
rm terraform.tfstate*

# Start fresh
terraform init
terraform apply
```

### Selective Reset
```bash
# Remove specific resources from state
terraform state rm module.apps

# Delete corresponding cluster resources
kubectl delete deployment,service -l app=server
kubectl delete deployment,service -l app=client

# Apply to recreate
terraform apply
```

## Best Practices

1. **Never Ctrl-C during apply** - let Terraform finish
2. **Always backup state** before manual interventions
3. **Use `terraform plan`** to preview changes
4. **Fix errors by updating configuration**, not by manual kubectl commands
5. **Import existing resources** instead of deleting them
6. **Use remote state** for production environments
7. **Monitor cluster separately** but don't interrupt Terraform

## Quick Recovery Checklist

- [ ] `terraform state list` - see what Terraform knows
- [ ] `kubectl get all -A` - see what's actually there
- [ ] `terraform plan` - see the diff
- [ ] Import missing resources or delete orphaned ones
- [ ] `terraform apply` - try again
- [ ] Never edit state file manually unless you really know what you're doing

## Remember

**Terraform is designed to be idempotent** - running `terraform apply` multiple times should be safe. If it's not, that's usually a configuration issue, not a Terraform issue.

The key is maintaining consistency between your state file and actual infrastructure.