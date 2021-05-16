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
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role.provisioner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.provisioner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_csi_driver.efs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/csi_driver) | resource |
| [kubernetes_daemonset.efs](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/daemonset) | resource |
| [kubernetes_deployment.efs_csi_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_service_account.csi_driver](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | Optional annotations to add to EFS CSI driver resources | `map(string)` | `{}` | no |
| <a name="input_controller_annotations"></a> [controller\_annotations](#input\_controller\_annotations) | A map of extra annotations for controller | `map(string)` | `{}` | no |
| <a name="input_controller_extra_node_selectors"></a> [controller\_extra\_node\_selectors](#input\_controller\_extra\_node\_selectors) | A map of extra node selectors for controller pods | `map(string)` | `{}` | no |
| <a name="input_create_controller"></a> [create\_controller](#input\_create\_controller) | Wheter to create a controller | `bool` | `false` | no |
| <a name="input_csi_controller_replica_count"></a> [csi\_controller\_replica\_count](#input\_csi\_controller\_replica\_count) | Number of EFS CSI driver controller pods | `number` | `2` | no |
| <a name="input_csi_controller_tolerations"></a> [csi\_controller\_tolerations](#input\_csi\_controller\_tolerations) | CSI driver controller tolerations | `list(map(string))` | `[]` | no |
| <a name="input_delete_access_point_root_dir"></a> [delete\_access\_point\_root\_dir](#input\_delete\_access\_point\_root\_dir) | Wheter to delete the access point root dir | `bool` | `false` | no |
| <a name="input_extra_node_selectors"></a> [extra\_node\_selectors](#input\_extra\_node\_selectors) | A map of extra node selectors for all components | `map(string)` | `{}` | no |
| <a name="input_host_aliases"></a> [host\_aliases](#input\_host\_aliases) | A map of host aliases | `map(any)` | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | A map of extra labels for all resources | `map(string)` | `{}` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | The log level for the CSI Driver controller | `number` | `5` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for EFS CSI driver resources | `string` | `"kube-system"` | no |
| <a name="input_node_extra_node_selectors"></a> [node\_extra\_node\_selectors](#input\_node\_extra\_node\_selectors) | A map of extra node selectors for node pods | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->