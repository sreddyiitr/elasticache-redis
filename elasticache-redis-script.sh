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
export SECURITY_GROUP_IDS=$(cat terraform.properties | grep '^[^#]' | grep security_group_ids | awk '{print $3}')
echo ${REDIS_CLUSTER_NAME}
echo ${SECURITY_GROUP_IDS}

cp ${repo}/elasticache-redis-template.tf elasticache-redis-current.tf

#For OS/X, -i should be -i '' This needs to be replaced with -i for Jenkins
# Sample - Replace variable with value
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/REDIS_CLUSTER_NAME/$REDIS_CLUSTER_NAME/
# Sample - Replace array variable with value
find . -name 'elasticache-redis-current.tf' -print0 | xargs -0 sed -i '' s/SECURITY_GROUP_IDS/$SECURITY_GROUP_IDS/



