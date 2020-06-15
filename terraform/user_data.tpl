#!/bin/bash
echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config;
echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
docker plugin install rexray/ebs REXRAY_PREEMPT=true EBS_REGION=${ebs_region} --grant-all-permissions;
stop ecs;
start ecs;