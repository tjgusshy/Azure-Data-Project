# 1. Resource Group
resource "azurerm_resource_group" "datalake_rg" {
  name     = "rg-datalake"
  location = "North Europe"
}

# 2. Random Suffix (Prevents naming conflicts during destroy/re-create cycles)
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# 3. The Data Lake Storage Account
resource "azurerm_storage_account" "datalake" {
  name                     = "medallion${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.datalake_rg.name
  location                 = azurerm_resource_group.datalake_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Cheapest option for personal use
  account_kind             = "StorageV2"
  is_hns_enabled           = true # Enables Data Lake Gen2 features
}

# 4. The Three Layers (Filesystems)
resource "azurerm_storage_data_lake_gen2_filesystem" "bronze" {
  name               = "01-bronze"
  storage_account_id = azurerm_storage_account.datalake.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "silver" {
  name               = "02-silver"
  storage_account_id = azurerm_storage_account.datalake.id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "gold" {
  name               = "03-gold"
  storage_account_id = azurerm_storage_account.datalake.id
}