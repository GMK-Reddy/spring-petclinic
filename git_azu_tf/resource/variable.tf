variable "app_service_name" {
    type = string
    description = "The name of the app service."
    default = "shiftleft-app"
}

variable "location" {
    type = string
    description = "The location of the app service."
    default = "West US"
}

variable "app_service_plan_id" {
    type = string
    description = "The plan of the app service."
    default = "B1"
}

variable "resource_group_name" {
    type = string
    description = "The name of the resource group in which to create the resource."
    default = "shiftleft-resource"
}

variable "expiration_date" {
    type = string
    description = "The expiration date of the resource."
    default = "1982-12-31T00:00:00Z"
}

variable "client_cert_enabled" {
    type = bool
    description = "Whether or not the client certificate is enabled."
    default = true
}

variable "ftps_state" {
    type = string
    description = "Whether or not FTPS is enabled."
    default = "FtpsOnly"
}

variable "min_tls_version" {
    type = number
    description = "The minimum TLS version."
    default = 1.2
}

variable "https_only" {
    type = bool
    description = "Whether or not HTTPS is enabled."
    default = false
}

variable "auth_settings_enabled" {
    type = bool
    description = "Whether or not the authentication settings are enabled."
    default = true
}

variable "identity" {
    type = string
    description = "The identity of the app service."
    default = "UserAssigned"
}

variable "public_network_access_enabled" {
    type = bool
    description = "Whether or not the public network access is enabled."
    default = false
}

variable "bypass" {
    type = list
    description = "A list of bypass rules."
    default = ["AzureServices"]
}

variable "default_action" {
    type = string
    description = "The default action of the bypass rule."
    default = "Deny"
}

variable "ip_rules" {
    type = list(string)
    description = "A list of IP rules."
    default = ["172.16.1.1","localhost","0.0.0.0"]
}

variable "enable_https_traffic_only" {
    type = bool
    description = "Whether or not HTTPS traffic only is enabled."
    default = true  
}

variable "sa_min_tls_version" {
    type = string
    description = "The minimum TLS version."
    default = "TLS1_2"
}

variable "logging" {
    type = bool
    description = "Whether or not logging is enabled."
    default = true
}

variable "account_kind" {
    type = string
    description = "The kind of the account."
    default = "StorageV2"
}

variable "account_tier" {
    type = string
    description = "The tier of the account."
    default = "Premium"
}

variable "start_ip_address" {
    type = string
    description = "The start IP address."
    default = "0.0.0.0"
}

variable "end_ip_address" {
    type = string
    description = "The end IP address."
    default = "255.255.255.255"
}

variable "managed_disk_type" {
    type = string
    description = "The type of the managed disk."
    default = "Standard_LRS"
}

variable "disk_name" {
    type = string
    description = "The name of the managed disk."
    default = "bds-managed-disk"
}

variable "disk_size_gb" {
    type = number
    description = "The size of the managed disk in GB."
    default = 10
}

variable "storage_account_type" {
    type = string
    description = "The type of the storage account."
    default = "Standard_LRS"
}

variable "common_tags" {
    type = map(string)
    description = "A map of common tags."
    default = {}
}

variable "ami_id" {
    type = string
    description = "The ID of the AMI."
    default = "ami-0000000000000000"
}

variable "instance_type" {
    type = string
    description = "The type of the instance."
    default = "Standard_DS1_v2"
}

variable "key_name" {
    type = string
    description = "The name of the key."
    default = "bds-key"
}

variable "instance_count" {
    type = number
    description = "The number of instances."
    default = 3
}

variable "volume_size" {
    type = number
    description = "The size of the volume in GB."
    default = 10
}

variable "security_group_ids" {
    type = list(string)
    description = "A list of security group IDs."
    default = []
}

variable "subnet_ids" {
    type = string
    description = "The ID of the subnet."
    default = ""
}

variable "ssl_enforcement_enabled" {
    type = bool
    description = "Whether SSL enforcement is enabled."
    default = true
}

variable "retention_policy_enabled" {
    type = bool
    description = "Whether or not retention policy is enabled."
    default = true  
}

variable "retention_policy_days" {
    type = number
    description = "The number of days for retention policy."
    default = 30
}

variable "direction" {
    type = string
    description = "The direction of the retention policy."
    default = "Inbound"
}

variable "access" {
    type = string
    description = "The access of the retention policy."
    default = "Allow"
}

variable "protocol" {
    type = string
    description = "The protocol of the retention policy."
    default = "Tcp"
}

variable "port_range" {
    type = string
    description = "The port range of the retention policy."
    default = "*"
}

variable "port_ranges" {
    type = list(string)
    description = "A list of port ranges."
    default = ["*"]
}

variable "source_address_prefix" {
    type = string
    description = "The source address prefix of the retention policy."
    default = "0.0.0.0"
}

variable "source_address_prefixes" {
    type = list(string)
    description = "A list of source address prefixes of the retention policy."
    default = []
}

variable "nsg_name" {
    type = string
    description = "The name of the network security group."
    default = "bds-nsg-1"
}
