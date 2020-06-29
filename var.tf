variable "username" {
  default = "admin"
}
variable "password" {
  default = "ciscopsdt"
}
variable "url" {
  default = "https://sandboxapicdc.cisco.com"
}
variable "tenant" {
  default = "mars"
}
variable "bd_subnet" {
  type    = string
  default = "10.1.1.1/24"
}

