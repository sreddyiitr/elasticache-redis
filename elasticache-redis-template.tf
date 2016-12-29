/* This is the template to create AWS ELASTICACHE REDIS CLUSTER with 
   corresponding ALARMs for CPU UTILIZATION and MEMORY on each CLUSTER
   
   Created by: Sunil Kothireddy
*/

provider "aws" {
  region = "AWS_REGION"
}

#ELASTICACHE REDIS RESOURCE
resource "aws_elasticache_replication_group" "REDIS_CLUSTER_NAME"  {

  replication_group_id          = "REDIS_CLUSTER_NAME"
  replication_group_description = "REDIS_CLUSTER_DESCRIPTION"
  node_type                     = "AWS_NODE_TYPE"
  number_cache_clusters         = "NUMBER_CACHE_CLUSTERS"
  port                          = "REDIS_PORT"
  parameter_group_name          = "REDIS_PARAMETER_GROUP"
# availability_zones            = [AWS_AVAILABILITY_ZONES]
  automatic_failover_enabled    = "IS_AUTO_FAILOVER_ENABLED"
  engine_version				= "REDIS_ENGINE_VERSION"
  subnet_group_name				= "SUBNET_GROUP_NAME"
  security_group_ids			= SECURITY_GROUP_IDS
  maintenance_window			= "MAINTENANCE_WINDOW"
  notification_arn				= ["ALERTS_SNS_TOPIC_NAME"]
  
  tags {
	REDISCACHETAGS
  }
 
}
#CLOUDWATCH ALARM RESOURCE - CPU UTILIZATION
resource "aws_cloudwatch_metric_alarm" "REDIS_CLOUDWATCH_ALARM_NAME_CPU" {
  count				          = "NUMBER_CACHE_CLUSTERS"
  alarm_name		          = "REDIS_CLOUDWATCH_ALARM_NAME_CPU00${count.index + 1}CPUUtilization"
  alarm_description			  = "REDIS_CLOUDWATCH_ALARM_CPU_DESCRIPTION"
  comparison_operator		  = "REDIS_CLOUDWATCH_ALARM_CPU_COMPARISON"
  evaluation_periods		  = "REDIS_CLOUDWATCH_ALARM_CPU_EVALUATION"
  metric_name				  = "REDIS_CLOUDWATCH_ALARM_CPU_METRIC_NAME"
  namespace				      = "REDIS_CLOUDWATCH_ALARM_CPU_AWS_EC"
  period				      = "REDIS_CLOUDWATCH_ALARM_CPU_PERIOD"
  statistic				      = "REDIS_CLOUDWATCH_ALARM_CPU_STATISTIC"
  threshold				      = "REDIS_CLOUDWATCH_ALARM_CPU_THRESHOLD"  
  alarm_actions				  = ["REDIS_CLOUDWATCH_ALARM_CPU_SNS_TOPIC_NAME"]
  
  dimensions {
  	CacheClusterId			=  "${aws_elasticache_replication_group.REDIS_CLUSTER_NAME.id}-00{count.index + 1}"
  }
}  

#CLOUDWATCH ALARM RESOURCE - MEMORY  
resource "aws_cloudwatch_metric_alarm" "REDIS_CLOUDWATCH_ALARM_NAME_MEMORY" {
  count				          = "NUMBER_CACHE_CLUSTERS"
  alarm_name		          = "REDIS_CLOUDWATCH_ALARM_NAME_MEMORY00${count.index + 1}FreeableMemory"
  alarm_description			  = "REDIS_CLOUDWATCH_ALARM_MEMORY_DESCRIPTION"
  comparison_operator		  = "REDIS_CLOUDWATCH_ALARM_MEMORY_COMPARISON"
  evaluation_periods		  = "REDIS_CLOUDWATCH_ALARM_MEMORY_EVALUATION"
  metric_name				  = "REDIS_CLOUDWATCH_ALARM_MEMORY_METRIC_NAME"
  namespace				      = "REDIS_CLOUDWATCH_ALARM_MEMORY_AWS_EC"
  period				      = "REDIS_CLOUDWATCH_ALARM_MEMORY_PERIOD"
  statistic				      = "REDIS_CLOUDWATCH_ALARM_MEMORY_STATISTIC"
  threshold				      = "REDIS_CLOUDWATCH_ALARM_MEMORY_THRESHOLD"  
  alarm_actions				  = ["REDIS_CLOUDWATCH_ALARM_MEMORY_SNS_TOPIC_NAME"]
  
  dimensions {
  	CacheClusterId			=  "${aws_elasticache_replication_group.REDIS_CLUSTER_NAME.id}-00{count.index + 1}"
  }
}
