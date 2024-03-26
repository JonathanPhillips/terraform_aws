#################################################################################################################
# Instance
#################################################################################################################
output "replication_instance_arn" {
  value       = aws_dms_replication_instance.this.replication_instance_arn
  description = "The Amazon Resource Name (ARN) of the DMS replication instance."
}

#################################################################################################################
# Endpoint
#################################################################################################################
output "source_endpoints" {
  value = {
    for k, v in aws_dms_endpoint.source : k => {
      endpoint_arn = v.endpoint_arn
      endpoint_id  = v.endpoint_id
    }
  }
  description = "A map of the source endpoints and their details."
}

#################################################################################################################
# S3 Endpoint
# #################################################################################################################
# output "s3_target_endpoints" {
#   value = {
#     for k, v in aws_dms_s3_endpoint.target : k => {
#       endpoint_arn = v.endpoint_arn
#       endpoint_id  = v.endpoint_id
#     }
#   }
#   description = "A map of the S3 target endpoints and their details."
# }

# #################################################################################################################
# # Replication Task
# #################################################################################################################
# output "replication_tasks" {
#   value = {
#     for k, v in aws_dms_replication_task.dms_source_to_s3_replication_task : k => {
#       replication_task_arn = v.replication_task_arn
#       replication_task_id  = v.replication_task_id
#     }
#   }
#   description = "A map of the replication tasks and their details."
# }
