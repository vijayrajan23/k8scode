# Generating the Data Encryption Config and Key
## The Encryption Key
## Code
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
## The Encryption Config File
## Code
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
## Copy the encryption-config.yaml encryption config file to each controller: