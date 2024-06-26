#!/bin/bash

set -e

# 引数の数をチェック
if [ $# -ne 1 ]; then
    echo "引数が必要です。testing または production を指定してください。"
    exit 1
fi

ENVIRONMENT_ARG=$1
# 引数が testing または production であるかをチェック
if [ "$ENVIRONMENT_ARG" != "testing" ] && [ "$ENVIRONMENT_ARG" != "production" ]; then
    echo "引数は development または production のいずれかを指定してください。"
    exit 1
fi

# productionに限り、mainブランチでのみのデプロイを許可する
if [ "$ENVIRONMENT_ARG" = "production" ]; then
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [ "$CURRENT_BRANCH" != "main" ]; then
        echo "productionをデプロイするならmainブランチでデプロイしてください。現在のブランチ:$CURRENT_BRANCH"
        exit 1
    fi
fi

docker-compose run --rm terraform bash -c "cd ./$ENVIRONMENT_ARG && terragrunt run-all plan"

docker-compose run --rm terraform bash -c "cd ./$ENVIRONMENT_ARG && terragrunt run-all apply"
