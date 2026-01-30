provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = var.purge_soft_delete_on_destroy
      recover_soft_deleted_key_vaults = var.recover_soft_deleted_key_vaults
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = "West Europe"
}
 resource "azurerm_key_vault_key" "good_example" {
   name         = "generated-certificate"
   key_vault_id = azurerm_key_vault.example.id
   key_type     = "RSA"
   key_size     = 2048
   expiration_date = var.expiration_date
 
   key_opts = [
     "decrypt",
     "encrypt",
     "sign",
     "unwrapKey",
     "verify",
     "wrapKey",
   ]
 }

resource "azurerm_app_service" "azurerm_app_service1" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id
  client_cert_enabled = var.client_cert_enabled
  
  site_config {
    ftps_state          = var.ftps_state
    min_tls_version     = var.min_tls_version
  }
}
resource "azurerm_app_service" "azurerm_app_service2" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id
  client_cert_enabled          = var.client_cert_enabled
  https_only                   = var.https_only
  auth_settings {
    enabled          = var.auth_settings_enabled
  }
  identity {
    type = var.identity
    identity_ids = "12345"
  }
}

resource "azurerm_app_service" "example" {
  name                = "example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id
  https_only          = var.https_only
  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    ftps_state          = var.ftps_state
    min_tls_version     = var.min_tls_version
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }
  auth_settings {
    enabled          = var.auth_settings_enabled
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}
resource "azurerm_key_vault_secret" "good_example" {
  name            = "secret-sauce"
  value           = "szechuan"
  key_vault_id    = azurerm_key_vault.example.id
  expiration_date = var.expiration_date
}

resource "azurerm_key_vault" "example" {
  name                = "example-kv"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku_name            = "standard"
  tenant_id           = "123"
  public_network_access_enabled = var.public_network_access_enabled

  network_acls {
    default_action = var.default_action
    bypass         = var.bypass
    ip_rules = var.ip_rules
  }
}

resource "azurerm_storage_account" "good_example" {
  name                      = "storageaccountname"
  resource_group_name       = azurerm_resource_group.example.name
  location                  = azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version          = var.sa_min_tls_version
  network_rules {
    default_action             = var.default_action
    ip_rules                   = var.ip_rules
    virtual_network_subnet_ids = [azurerm_subnet.example.id]
    bypass                     = var.bypass
  }
}

resource "azurerm_storage_account" "bdsdevops_storage" {
  name                     = "example"
  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version          = var.sa_min_tls_version
  identity {
    type = var.identity
  }
  queue_properties  {
    logging {
      delete                = var.logging
      read                  = var.logging
      write                 = var.logging
      version               = "1.0"
      retention_policy_days = 10
    }
  }
}

resource "azurerm_storage_account_network_rules" "bdsdevops_rules" {
  storage_account_id = azurerm_storage_account.bdsdevops_storage.id
  default_action             = "Deny"
  ip_rules                   = var.ip_rules
  virtual_network_subnet_ids = [azurerm_subnet.test.id]
  bypass                     = var.bypass
}

resource "azurerm_storage_account_customer_managed_key" "example" {
  storage_account_id = azurerm_storage_account.bdsdevops_storage.id
  key_vault_id       = azurerm_key_vault.example.id
  key_name           = azurerm_key_vault_key.example.name
}

resource "azurerm_storage_account" "test_bc_storage" {
  name                     = "examplestor"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = "GRS"

  identity {
    type = var.identity
  }

  customer_managed_key {
    key_vault_key_id = azurerm_key_vault_key.kvkey[0].id
    user_assigned_identity_id = azurerm_user_assigned_identity.identity[0].id
  }
}
resource "azurerm_sql_server" "sql_server_good" {
  name                         = "mysqlserver"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}
resource "azurerm_sql_active_directory_administrator" "example" {
server_name         = azurerm_sql_server.sql_server_good.name
  resource_group_name = azurerm_resource_group.example.name
  login               = "sqladmin"
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}
resource "azurerm_sql_firewall_rule" "sql_server_good_firewall" {
  name                = "FirewallRule1"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_sql_server.sql_server_good.name
  start_ip_address    = var.start_ip_address
  end_ip_address      = var.end_ip_address
}

resource "azurerm_virtual_machine" "virtual_machine_good" {
  name                  = "my-vm"
  location              = "location"
  resource_group_name   = "group_name"
  network_interface_ids = ["1234567"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.managed_disk_type
  }
}
resource "azurerm_virtual_machine" "jenkins_server" {
  name                  = "test-vm"
  location              = "location"
  resource_group_name   = "group_name"
  network_interface_ids = ["1234567"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_id = azurerm_managed_disk.example.id
  }
  }
 resource "azurerm_managed_disk" "example" {
  name                 = var.disk_name
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_gb
  disk_encryption_set_id = azurerm_disk_encryption_set.example[0].id
  tags = var.common_tags
}

resource "azurerm_managed_disk" "managed_disk_good_1" {
  name                 = "acctestmd"
  location             = "West US 2"
  resource_group_name  = azurerm_resource_group.group.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
  encryption_settings {
    disk_encryption_key {
        secret_url = 123445
        source_vault_id = azurerm_key_vault.example.id
    }
    key_encryption_key {
        key_url = 123445
        source_vault_id = azurerm_key_vault.example.id
    }
  }
  tags = {
    environment = "staging"
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  count         = var.instance_count
  user_data = base64encode(file("${path.module}/user-data.sh")) 

  root_block_device {
    volume_size = var.volume_size  # Size in GB
    volume_type = "gp2"  # EBS volume type
  }
  
  vpc_security_group_ids = var.security_group_ids

  subnet_id = element(var.subnet_ids, count.index % length(var.subnet_ids))

  tags = merge(
    {
      Name        = "environment-application"
      Environment = "environment-1"
      Owner       = "murali"
      CostCenter  = "123"
      Application = "test"
    }
  )
}

resource "azurerm_mysql_server" "example" {
  name                = "example-mysqlserver"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = var.public_network_access_enabled
  ssl_enforcement_enabled           = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_network_watcher_flow_log" "test" {
  network_watcher_name = azurerm_network_watcher.test.name
  resource_group_name  = azurerm_resource_group.example.name
  name                 = "example-log"

  network_security_group_id = azurerm_network_security_group.test.id
  storage_account_id        = azurerm_storage_account.test.id
  enabled                   = true

  retention_policy {
    enabled = var.retention_policy_enabled
    days    = var.retention_policy_days
  }
  }

resource "azurerm_postgresql_server" "shiftleft_server" {
  name                = "example-psqlserver"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  administrator_login          = "psqladmin"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "GP_Gen5_4"
  version    = "11"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = var.public_network_access_enabled
  ssl_enforcement_enabled          = var.ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced = "TLS1_2"
}
resource "azurerm_postgresql_firewall_rule" "shiftleft_server_firewall" {
  name                = "office"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_postgresql_server.shiftleft_server.name
  start_ip_address    = var.start_ip_address
  end_ip_address      = var.end_ip_address
}

resource "azurerm_network_security_group" "bc-security" {
   name                = "tf-appsecuritygroup"
   location            = azurerm_resource_group.example.location
   resource_group_name = azurerm_resource_group.example.name
   
   security_rule {
     direction                   = var.direction
     access                      = var.access
     protocol                    = var.protocol
     source_port_range           = "any"
     destination_port_range      = var.port_range
     source_address_prefixes     = var.source_address_prefixes
     destination_address_prefix  = "*"
   }
 }

resource "azurerm_network_security_rule" "bc-security_rule" {
  name                        = "test123"
  priority                    = 100
  direction                   = var.direction
  access                      = var.access
  protocol                    = var.protocol
  source_port_ranges          = var.port_ranges
  destination_port_ranges     = var.port_ranges
  source_address_prefix       = var.source_address_prefix
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.bc-security.name
}

resource "azurerm_network_security_group" "bds-security" {
   name                = "tf-bds-security"
   location            = azurerm_resource_group.example.location
   resource_group_name = azurerm_resource_group.example.name
   
   security_rule {
     direction                     = var.direction
     access                        = var.access
     protocol                      = var.protocol
     source_port_range             = "any"
     destination_port_ranges       = var.port_ranges
     source_address_prefix         = var.source_address_prefix
     destination_address_prefixes  = ["*","0.0.0.0","172.16.1.168"]
   }
 }
 
resource "azurerm_network_security_rule" "bds-security-group" {
   direction                   = var.direction
   access                      = var.access
   protocol                    = var.protocol
   destination_port_range      = var.port_range
   source_address_prefixes     = var.source_address_prefixes
   destination_address_prefix  = "*"
   resource_group_name         = azurerm_resource_group.bds-security.name
   network_security_group_name = azurerm_network_security_group.example.name
   priority                    = 100
   name                        = var.nsg_name
}
