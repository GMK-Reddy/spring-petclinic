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

variable "default_action" {
    type = string
    description = "The default action of the bypass rule."
    default = "Deny"
}

variable "source_address_prefixes" {
    type = list(string)
    description = "A list of source address prefixes of the retention policy."
    default = ["0.0.0.0", "10.0.0.0"]
}
