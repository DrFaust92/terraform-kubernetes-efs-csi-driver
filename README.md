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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.48.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.16.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.64.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.20.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_with_oidc"></a> [iam\_assumable\_role\_with\_oidc](#module\_iam\_assumable\_role\_with\_oidc) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.efs_controller_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [kubernetes_cluster_role.efs_csi_external_provisioner_role](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.efs_csi_provisioner_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_csi_driver_v1.efs_csi_aws_com](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/csi_driver_v1) | resource |
| [kubernetes_daemonset.efs_csi_node](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/daemonset) | resource |
| [kubernetes_deployment.efs_csi_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_secret.csi_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.csi_node](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_service_account.csi_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [kubernetes_service_account.csi_node](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_csi_controller_replica_count"></a> [csi\_controller\_replica\_count](#input\_csi\_controller\_replica\_count) | Number of EFS CSI driver controller pods | `number` | `2` | no |
| <a name="input_delete_access_point_root_dir"></a> [delete\_access\_point\_root\_dir](#input\_delete\_access\_point\_root\_dir) | Wheter to delete the access point root dir | `bool` | `false` | no |
| <a name="input_driver_release"></a> [driver\_release](#input\_driver\_release) | The EFS CSI driver release version | `string` | `"v1.5.3"` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | The log level for the CSI Driver controller | `number` | `2` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for EFS CSI driver resources | `string` | `"kube-system"` | no |
| <a name="input_node_selector"></a> [node\_selector](#input\_node\_selector) | NodeSelector map | `map(string)` | `{}` | no |
| <a name="input_oidc_url"></a> [oidc\_url](#input\_oidc\_url) | EKS OIDC provider URL, to allow pod to assume role using IRSA | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs-csi_driver_controller_role_name"></a> [efs-csi\_driver\_controller\_role\_name](#output\_efs-csi\_driver\_controller\_role\_name) | The Name of the EBS CSI driver controller IAM role name |
| <a name="output_efs_csi_driver_controller_role_arn"></a> [efs\_csi\_driver\_controller\_role\_arn](#output\_efs\_csi\_driver\_controller\_role\_arn) | The Name of the EBS CSI driver controller IAM role ARN |
| <a name="output_efs_csi_driver_controller_role_policy_arn"></a> [efs\_csi\_driver\_controller\_role\_policy\_arn](#output\_efs\_csi\_driver\_controller\_role\_policy\_arn) | The Name of the EBS CSI driver controller IAM role policy ARN |
| <a name="output_efs_csi_driver_controller_role_policy_name"></a> [efs\_csi\_driver\_controller\_role\_policy\_name](#output\_efs\_csi\_driver\_controller\_role\_policy\_name) | The Name of the EBS CSI driver controller IAM role policy name |
| <a name="output_efs_csi_driver_name"></a> [efs\_csi\_driver\_name](#output\_efs\_csi\_driver\_name) | The Name of the EBS CSI driver |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
