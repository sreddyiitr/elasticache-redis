#!/bin/bash
#export https_proxy=
#export http_proxy=
#export AWS_ACCESS_KEY_ID=${aws_access_key}
#export AWS_SECRET_ACCESS_KEY=${aws_secret_key}
#export AWS_SESSION_TOKEN=${aws_session_token}
#export AWS_DEFAULT_REGION=${aws_default_region}

#Check if terraform is installed
#/opt/beasys/terraform/terraform --version

#echo $WORKSPACE
#cd $WORKSPACE

whoami
rm -Rf *

#Set git token to test from local. This can be an input value in Jenkins job
repo="git_template_repo"
parameter_file="https://raw.githubusercontent.com/sreddyiitr/elasticache-redis/master/elasticache-redis-parameters.properties"
git_token="abcdefghijk893r8"
git_clone_url="https://${git_token}@github.com/sreddyiitr/elasticache-redis"

git clone ${git_clone_url} ${repo}
wget ${parameter_file} -O terraform.properties

export REDIS_CLUSTER_NAME=$(cat terraform.properties | grep '^[^#]' | grep elasticache_cluster_name | awk -F'\"' '{print $2}')
export REDIS_CLUSTER_DESCRIPTION=$(cat terraform.properties | grep '^[^#]' | grep elasticache_cluster_description | awk -F'\"' '{print $2}')
export IS_AUTO_FAILOVER_ENABLED=$(cat terraform.properties | grep '^[^#]' | grep enable_automatic_failover | awk -F'\"' '{print $2}')
export NUMBER_CACHE_CLUSTERS=$(cat terraform.properties | grep '^[^#]' | grep number_of_cache_clusters | awk -F'\"' '{print $2}')
export AWS_NODE_TYPE=$(cat terraform.properties | grep '^[^#]' | grep node_type | awk -F'\"' '{print $2}')
export REDIS_PORT=$(cat terraform.properties | grep '^[^#]' | grep elasticache_port | awk -F'\"' '{print $2}')
export REDIS_ENGINE_VERSION=$(cat terraform.properties | grep '^[^#]' | grep engine_version | awk -F'\"' '{print $2}')
export REDIS_PARAMETER_GROUP=$(cat terraform.properties | grep '^[^#]' | grep parameter_group_name | awk -F'\"' '{print $2}')
export SUBNET_GROUP_NAME=$(cat terraform.properties | grep '^[^#]' | grep sunbet_group_name | awk -F'\"' '{print $2}')
export MAINTENANCE_WINDOW=$(cat terraform.properties | grep '^[^#]' | grep maintenance_window | awk -F'\"' '{print $2}')
export ALERTS_SNS_TOPIC_NAME=$(cat terraform.properties | grep '^[^#]' | grep notification_topic_arn | awk -F'\"' '{print $2}')
export SECURITY_GROUP_IDS=$(cat terraform.properties | grep '^[^#]' | grep security_group_ids | awk '{print $3}')

export REDIS_CLOUDWATCH_ALARM_NAME_CPU=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_cpu_utilization_alarm_name | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_CPU_DESCRIPTION=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_cpu_utilization_alarm_description | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_CPU_COMPARISON=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_cpu_utilization_alarm_comparison | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_CPU_EVALUATION=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_cpu_utilization_alarm_evaluation | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_CPU_METRIC_NAME=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_cpu_utilization_alarm_metric_name | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_CPU_AWS_EC=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_cpu_utilization_alarm_awsnamespace | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_CPU_PERIOD=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_cpu_utilization_alarm_period | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_CPU_STATISTIC=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_cpu_utilization_alarm_statistic | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_CPU_THRESHOLD=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_cpu_utilization_alarm_threshold | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_CPU_SNS_TOPIC_NAME=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_cpu_utilization_alarm_sns_topic_name | awk -F'\"' '{print $2}')

export REDIS_CLOUDWATCH_ALARM_NAME_MEMORY=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_memory_alarm_name | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_MEMORY_DESCRIPTION=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_memory_alarm_description | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_MEMORY_COMPARISON=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_memory_alarm_comparison | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_MEMORY_EVALUATION=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_memory_alarm_evaluation | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_MEMORY_METRIC_NAME=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_memory_alarm_metric_name | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_MEMORY_AWS_EC=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_memory_alarm_namespace | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_MEMORY_PERIOD=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_memory_alarm_period | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_MEMORY_STATISTIC=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_memory_alarm_statistic | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_MEMORY_THRESHOLD=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_memory_alarm_threshold | awk -F'\"' '{print $2}')
export REDIS_CLOUDWATCH_ALARM_MEMORY_SNS_TOPIC_NAME=$(cat terraform.properties | grep '^[^#]' | grep cloudwatch_memory_alarm_sns_topic_name | awk -F'\"' '{print $2}')

echo ${REDIS_CLOUDWATCH_ALARM_NAME_CPU}
echo ${REDIS_CLOUDWATCH_ALARM_NAME_MEMORY}
#echo ${SECURITY_GROUP_IDS}

cp ${repo}/elasticache-redis-template.tf elasticache-redis-current.tf

#For OS/X, -i should be -i '' This needs to be replaced with -i for Jenkins
# Sample - Replace variable with value
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLUSTER_NAME/$REDIS_CLUSTER_NAME/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/SECURITY_GROUP_IDS/$SECURITY_GROUP_IDS/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' "s/REDIS_CLUSTER_DESCRIPTION/$REDIS_CLUSTER_DESCRIPTION/"
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/IS_AUTO_FAILOVER_ENABLED/$IS_AUTO_FAILOVER_ENABLED/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/NUMBER_CACHE_CLUSTERS/$NUMBER_CACHE_CLUSTERS/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/AWS_NODE_TYPE/$AWS_NODE_TYPE/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_PORT/$REDIS_PORT/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_ENGINE_VERSION/$REDIS_ENGINE_VERSION/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_PARAMETER_GROUP/$REDIS_PARAMETER_GROUP/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/SUBNET_GROUP_NAME/$SUBNET_GROUP_NAME/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/MAINTENANCE_WINDOW/$MAINTENANCE_WINDOW/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/ALERTS_SNS_TOPIC_NAME/$ALERTS_SNS_TOPIC_NAME/

find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_CPU_NAME/$REDIS_CLOUDWATCH_ALARM_CPU_NAME/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' "s/REDIS_CLOUDWATCH_ALARM_CPU_DESCRIPTION/$REDIS_CLOUDWATCH_ALARM_CPU_DESCRIPTION/"
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_CPU_COMPARISON/$REDIS_CLOUDWATCH_ALARM_CPU_COMPARISON/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_CPU_EVALUATION/$REDIS_CLOUDWATCH_ALARM_CPU_EVALUATION/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_CPU_METRIC_NAME/$REDIS_CLOUDWATCH_ALARM_CPU_METRIC_NAME/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' "s~REDIS_CLOUDWATCH_ALARM_CPU_AWS_EC~$REDIS_CLOUDWATCH_ALARM_CPU_AWS_EC~"
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_CPU_PERIOD/$REDIS_CLOUDWATCH_ALARM_CPU_PERIOD/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_CPU_STATISTIC/$REDIS_CLOUDWATCH_ALARM_CPU_STATISTIC/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_CPU_THRESHOLD/$REDIS_CLOUDWATCH_ALARM_CPU_THRESHOLD/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_CPU_SNS_TOPIC_NAME/$REDIS_CLOUDWATCH_ALARM_CPU_SNS_TOPIC_NAME/

find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_MEMORY_NAME/$REDIS_CLOUDWATCH_ALARM_MEMORY_NAME/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' "s/REDIS_CLOUDWATCH_ALARM_MEMORY_DESCRIPTION/$REDIS_CLOUDWATCH_ALARM_MEMORY_DESCRIPTION/"
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_MEMORY_COMPARISON/$REDIS_CLOUDWATCH_ALARM_MEMORY_COMPARISON/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_MEMORY_EVALUATION/$REDIS_CLOUDWATCH_ALARM_MEMORY_EVALUATION/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_MEMORY_METRIC_NAME/$REDIS_CLOUDWATCH_ALARM_MEMORY_METRIC_NAME/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' "s~REDIS_CLOUDWATCH_ALARM_MEMORY_AWS_EC~$REDIS_CLOUDWATCH_ALARM_MEMORY_AWS_EC~"
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_MEMORY_PERIOD/$REDIS_CLOUDWATCH_ALARM_MEMORY_PERIOD/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_MEMORY_STATISTIC/$REDIS_CLOUDWATCH_ALARM_MEMORY_STATISTIC/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_MEMORY_THRESHOLD/$REDIS_CLOUDWATCH_ALARM_MEMORY_THRESHOLD/
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLOUDWATCH_ALARM_MEMORY_SNS_TOPIC_NAME/$REDIS_CLOUDWATCH_ALARM_MEMORY_SNS_TOPIC_NAME/


