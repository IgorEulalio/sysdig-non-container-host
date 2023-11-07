variable "sysdig_accesskey" {
  description = "sysdig access key"
  sensitive   = true
  type        = string
}

variable "aws_profile" {
  description = "aws profile to use."
  type        = string
  default     = "sysdig"
}

variable "aws_region" {
  description = "aws region to be used"
  type        = string
  default     = "us-east-1"
}

variable "sysdig_secure_url" {
  description = "endpoint for sysdig secure"
  type        = string
  default     = "https://app.us4.sysdig.com"
}

variable "sysdig_secure_api_token" {
  description = "sysdig secure api token"
  type        = string
  sensitive   = true
}

