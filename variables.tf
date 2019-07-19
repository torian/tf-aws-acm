# vim:ts=2:sw=2:et:

variable "zone_id" {
  description = ""
}

variable "crt_hostnames" {
  description = ""
  type        = list
  default     = []
}

variable "tags" {
  description = ""
  type        = map
  default     = {}
}

