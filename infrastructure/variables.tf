variable "repository" {
  type        = string
  default     = "github.com/RaniSputnik/ryanloader.me"
  description = "Where I can find this infrastructure's config"
}

variable "primary_zone" {
  type        = string
  default     = "ryanloader.me"
  description = "The main domain that is being deployed"
}
