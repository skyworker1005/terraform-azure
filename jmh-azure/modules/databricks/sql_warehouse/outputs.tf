output "sql_warehouse_id" {
  value       = databricks_sql_endpoint.sql_warehouse.id
  description = "The ID of the SQL warehouse."
}

output "sql_warehouse_name" {
  value       = databricks_sql_endpoint.sql_warehouse.name
  description = "The name of the SQL warehouse."
}
