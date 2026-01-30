module "siftleft_services" {
  source                        = "./resource"
  app_service_name              = "siftleft-app"
  location                      = "West US"
  resource_group_name           = "shiftleft-resource"
  expiration_date               = "1982-12-31T00:00:00Z"
  client_cert_enabled           = true
  ftps_state                    = "FtpsOnly"
  min_tls_version               = 1.2
  https_only                    = var.https_only
  auth_settings_enabled         = var.auth_settings_enabled
  identity                      = var.identity
  public_network_access_enabled = var.public_network_access_enabled
  bypass                        = ["AzureServices", "Metrics"]
  default_action                = var.default_action
  ip_rules                      = ["172.16.1.1","localhost","0.0.0.0"]
  enable_https_traffic_only     = false
  sa_min_tls_version            = "TLS1_2"
  logging                       = false
  account_kind                  = "StorageV2"
  account_tier                  = "Premium"
  start_ip_address              = "0.0.0.0"
  end_ip_address                = "255.255.255.255"
  managed_disk_type             = "Standard_LRS"
  disk_size_gb                  = 1024
  disk_name                     = "bds-managed-disk"
  storage_account_type          = "Standard_LRS"
  ssl_enforcement_enabled       = false
  retention_policy_enabled      = false
  direction                     = "Inbound"
  access                        = "Allow"
  protocol                      = "Tcp"
  port_range                    = "22"
  port_ranges                   = ["22", "3389"]
  source_address_prefix         = "0.0.0.0/0"
  source_address_prefixes       = var.source_address_prefixes

}
