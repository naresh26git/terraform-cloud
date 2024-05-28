# provider
variable "aws_region" {
  type        = string
  description = "region"
  default     = "ap-south-1"
}
# vpc
variable "cidr_vpc" {
  type        = string
  description = "cidr"
  default     = "10.0.0.0/16"
}
# subnet pub
variable "subpub1" {
  type        = string
  description = "pubsub1"
  default     = "10.0.1.0/24"
}
variable "subpub2" {
  type        = string
  description = "pubsub1"
  default     = "10.0.2.0/24"
}
# subnet pvt
variable "subpvt1" {
  type        = string
  description = "pvtsub1"
  default     = "10.0.3.0/24"
}
variable "subpvt2" {
  type        = string
  description = "pvtsub2"
  default     = "10.0.4.0/24"
}
#az_subnet_pub
variable "az_subnet_pub1" {
  type        = string
  description = "zone"
  default     = "ap-south-1a"
}
variable "az_subnet_pub2" {
  type        = string
  description = "zone"
  default     = "ap-south-1b"
}
#az_subnet_pvt
variable "az_subnet_pvt1" {
  type        = string
  description = "zone"
  default     = "ap-south-1a"
}
variable "az_subnet_pvt2" {
  type        = string
  description = "zone"
  default     = "ap-south-1b"
}