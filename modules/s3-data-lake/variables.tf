variable "project" { type = string }
variable "environment" { type = string }
variable "tags" { type = map(string) }
locals {
    data_path = "${path.module}/data/pizza_data.csv"
}