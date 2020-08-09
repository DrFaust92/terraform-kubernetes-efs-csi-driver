# Kubernetes EFS CSI driver Terraform module 

Terraform module which creates Kubernetes EFS CSI driver resources on AWS EKS.

Based on the original repo for the [EFS CSI driver](https://github.com/kubernetes-sigs/aws-efs-csi-driver)

## Usage

```hcl
module "efs_csi_driver" {
  source = "DrFaust92/efs-csi-driver/kubernetes"
  version = "<VERSION>"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| kubernetes | ~> 1.11.4 |

## Providers

| Name | Version |
|------|---------|
| kubernetes | ~> 1.11.4 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| annotations | Optional annotations to add to EFS CSI driver resources | `map(string)` | `{}` | no |
| namespace | Namespace for EFS CSI driver resources | `string` | `"kube-system"` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->