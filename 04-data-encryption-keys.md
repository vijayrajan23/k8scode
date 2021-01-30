# Generating the Data Encryption Config and Key
## The Encryption Key
```
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
```
## The Encryption Config File
```
cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF
```
## Copy the encryption-config.yaml encryption config file to each controller:
```
#!/bin/bash
# master certificates move
for instance in master1.mylap.in master2.mylap.in; do
  scp   encryption-config.yaml 	  ubuntu@${instance}:~/k8s/
done
```
