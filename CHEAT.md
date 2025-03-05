# Cheat Sheet

## AWS CLI

```shell
# Fetch a secret value from AWS Secrets Manager
aws secretsmanager get-secret-value \
  --secret-id "secret-name" \
  --query 'SecretString' \
  --no-paginate \
  --output text

# Tunnel a port from AWS Systems Manager Session Manager
aws ssm start-session \
  --target i-xxx \
  --document-name AWS-StartPortForwardingSessionToRemoteHost \
  --parameters '{"portNumber":["remotePort#"],"localPortNumber":["localPort#"],"host":["hostnameToTarget"]}'
```

## Docker

```shell
# access localhost from within docker container using Docker Desktop
host.docker.internal
```
