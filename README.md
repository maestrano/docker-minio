# Maestrano Minio
Docker image packed with [Minio](https://minio.io/) - a S3-like Cloud Storage Service

[![Build Status](https://travis-ci.org/maestrano/docker-minio.svg?branch=master)](https://travis-ci.org/maestrano/docker-minio)

## Examples
Launch Minio with specific root credentials
```
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export S3_ENDPOINT="http://localhost:9000"

docker run -p 9000:9000 -d \
  -e "MINIO_ACCESS_KEY=$AWS_ACCESS_KEY_ID" \
  -e "MINIO_SECRET_KEY=$AWS_SECRET_ACCESS_KEY" \
  maestrano/minio
```

Create a bucket (assumes you've exported the AWS_ variables above)
```
aws --endpoint-url $S3_ENDPOINT s3 mb s3://mybucket
```

Add an object to the bucket
```
touch myfile.txt
aws --endpoint-url $S3_ENDPOINT s3 cp myfile.txt s3://mybucket
```

Download a file
```
rm -f myfile.txt # delete previously created file
aws --endpoint-url $S3_ENDPOINT s3 cp s3://mybucket/myfile.txt myfile.txt
```

Add a public folder
```
# Add policy on mybucket to make the /public folder publicly readable
aws --endpoint-url $S3_ENDPOINT s3api put-bucket-policy \
  --bucket mybucket \
  --policy '{"Version":"2012-10-17","Statement":[{"Effect": "Allow","Principal": "*","Action": "s3:GetObject","Resource": "arn:aws:s3:::mybucket/public/*"}]}'

# Add file under public directory
aws --endpoint-url $S3_ENDPOINT s3 cp myfile.txt s3://mybucket/public/

# Below command should be successful
curl $S3_ENDPOINT/mybucket/public/myfile.txt
```

Access the minio UI:
1. Go to http://localhost:9000
2. Enter the root credentials exported above to login

## Docker Healthcheck
The image provides a **default Docker healthcheck** which curls the minio login page. The healthcheck can be disabled by adding "NO_HEALTHCHECK=true" to the list of container environment variables.
