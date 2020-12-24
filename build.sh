#!/bin/bash

AWS_ACCOUNT_ID=$1
AWS_REGION=ap-northeast-1
AWS_ECR=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

function docker_build_and_push_registory() {
    BUILD_TAG=$1
    docker build --target ${BUILD_TAG} -t lambda-run:${BUILD_TAG} -f Dockerfile.lambda  .
    docker tag lambda-run:${BUILD_TAG} ${AWS_ECR}/lambda-run:${BUILD_TAG}
    docker push ${AWS_ECR}/lambda-run:${BUILD_TAG}
}

aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ECR}
docker_build_and_push_registory app
docker_build_and_push_registory migrate
