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

## PFCTL Port Redirect

```shell
# Create a file /etc/pf.anchors/dev with the following rules:
# rdr pass inet proto tcp from any to any port 80 -> 127.0.0.1 port 8080
# rdr pass inet proto tcp from any to any port 443 -> 127.0.0.1 port 8443

# Edit /etc/pf.conf:
# Find the line:
#   rdr-anchor "com.apple/*"
# Below it, add:
#   rdr-anchor "dev"
#   load anchor "dev" from "/etc/pf.anchors/dev"

# Test the PF configuration (dry-run):
sudo pfctl -v -n -f /etc/pf.conf

# Enable PF (if needed) and load rules:
sudo pfctl -e -f /etc/pf.conf
```
