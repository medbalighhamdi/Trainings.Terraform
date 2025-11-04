
# [tfsec] Results
## Failed: 7 issue(s)
| # | ID | Severity | Title | Location | Description |
|---|----|----------|-------|----------|-------------|
| 1 | `azure-storage-use-secure-tls-policy` | *CRITICAL* | _The minimum TLS version for Storage Accounts should be TLS1_2_ | `C:\Users\mohamed.baligh.hamdi\source\repos\terraform\structure\modules\storage\main.tf:19-25` | Storage account uses an insecure TLS version. |
| 2 | `azure-storage-use-secure-tls-policy` | *CRITICAL* | _The minimum TLS version for Storage Accounts should be TLS1_2_ | `C:\Users\mohamed.baligh.hamdi\source\repos\terraform\structure\modules\compute\main.tf:43-49` | Storage account uses an insecure TLS version. |
| 3 | `custom-custom-azure001` | *HIGH* | _First check on my terraform scripts_ | `C:\Users\mohamed.baligh.hamdi\source\repos\terraform\structure\modules\storage\main.tf:19-25` | Custom check failed for resource module.storage.azurerm_storage_account.st-structure-001. Error |
| 4 | `custom-custom-azure001` | *HIGH* | _First check on my terraform scripts_ | `C:\Users\mohamed.baligh.hamdi\source\repos\terraform\structure\modules\networking\main.tf:44-52` | Custom check failed for resource module.networking.azurerm_subnet.snet-structure-001. Error |
| 5 | `custom-custom-azure001` | *HIGH* | _First check on my terraform scripts_ | `C:\Users\mohamed.baligh.hamdi\source\repos\terraform\structure\modules\networking\main.tf:37-42` | Custom check failed for resource module.networking.azurerm_virtual_network.vnet-structure-001. Error |
| 6 | `custom-custom-azure001` | *HIGH* | _First check on my terraform scripts_ | `C:\Users\mohamed.baligh.hamdi\source\repos\terraform\structure\modules\compute\main.tf:43-49` | Custom check failed for resource module.compute.azurerm_storage_account.st-structure-003. Error |
| 7 | `custom-custom-azure001` | *HIGH* | _First check on my terraform scripts_ | `C:\Users\mohamed.baligh.hamdi\source\repos\terraform\structure\modules\compute\main.tf:26-41` | Custom check failed for resource module.compute.azurerm_subnet.snet-structure-002. Error |

