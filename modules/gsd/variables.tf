variable "region" {
  default = "us-central1"
}

variable "sql_root_user_name" {
  description = "The username of root"
  type        = string
  default     = "postgres"
}

variable "sql_root_user_pw" {
  description = "The password of root"
  type        = string
  default     = "postgres"
}

variable "db_version" {
  description = "The version of database"
  type        = string
  default     = "POSTGRES_11"
}

variable "network" {
  description = "The network of database"
}

variable "db_tier" {
  description = "The tier of db"
  type        = string
  default     = "db-g1-small"
}
