#!/bin/sh

set -ex

if [ -z "$AWS_ACCESS_KEY_ID_TESTBOX" ]; then
  echo "AWS_ACCESS_KEY_ID_TESTBOX is not set. Quitting."
  exit 1
fi

if [ -z "$AWS_SECRET_ACCESS_KEY_TESTBOX" ]; then
  echo "AWS_SECRET_ACCESS_KEY_TESTBOX is not set. Quitting."
  exit 1
fi

# Default to eu-central-1 if AWS_REGION not set.
if [ -z "$AWS_REGION" ]; then
  AWS_REGION="eu-central-1"
fi

AWS_S3_BUCKET=testbox-"$(echo $GITHUB_REF | sed 's:.*/::')"

aws configure --profile s3-action <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID_TESTBOX}
${AWS_SECRET_ACCESS_KEY_TESTBOX}
${AWS_REGION}
text
EOF

echo $HOME
echo $GITHUB_JOB
echo $GITHUB_REF
echo $GITHUB_SHA
echo $GITHUB_REPOSITORY
echo $GITHUB_REPOSITORY_OWNER
echo $GITHUB_RUN_ID
echo $GITHUB_RUN_NUMBER
echo $GITHUB_ACTOR
echo $GITHUB_WORKFLOW
echo $GITHUB_HEAD_REF
echo $GITHUB_BASE_REF
echo $GITHUB_EVENT_NAME
echo $GITHUB_SERVER_URL
echo $GITHUB_API_URL
echo $GITHUB_GRAPHQL_URL
echo $GITHUB_WORKSPACE
echo $GITHUB_ACTION
echo $GITHUB_EVENT_PATH
echo $RUNNER_OS
echo $RUNNER_TOOL_CACHE
echo $RUNNER_TEMP
echo $RUNNER_WORKSPACE
echo $ACTIONS_RUNTIME_URL
echo $ACTIONS_RUNTIME_TOKEN
echo $ACTIONS_CACHE_URL


# Create S3 bucket
BUCKET_NAME=$(aws s3 ls | grep ${AWS_S3_BUCKET} | awk '{print $3}')

if [ -z "${BUCKET_NAME}" ];
then
  echo "This is the bucket name: $AWS_S3_BUCKET"
  echo "just another echo"

#    sh -c "aws s3 mb s3://${AWS_S3_BUCKET} \
#                --profile s3-action \
#                --region ${AWS_REGION}"
#  echo "creating the bucket"
#
#  sh -c "aws s3 cp ${GITHUB_WORKSPACE} s3://${AWS_S3_BUCKET}/ \
#                --profile s3-action \
#                --recursive"
#  echo "Copying files"
else
#  sh -c "aws s3 sync ${GITHUB_WORKSPACE} s3://${AWS_S3_BUCKET}/ \
#              --profile s3-action \
#              --no-progress"
  echo "ELSE - This is the bucket name: $AWS_S3_BUCKET"
  echo "yet another echo"
  echo "syncing files"
fi

# Clear out credentials after we're done.
aws configure --profile s3-action <<-EOF > /dev/null 2>&1
null
null
null
text
EOF
