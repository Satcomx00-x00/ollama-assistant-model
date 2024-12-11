#!/bin/bash

# build_secure.sh

# Generate a random password
ENCRYPT_KEY=$(openssl rand -base64 32)

# First create the PyInstaller executable without encryption
echo "Creating PyInstaller executable..."
pyinstaller --clean \
    --onefile \
    --name n8n_credential_manager \
    n8n_set_ollama_endpoint.py

# Create a temporary directory for packaging
mkdir -p temp_build

# Encrypt the executable
echo "Encrypting executable..."
openssl enc -aes-256-cbc -salt -in dist/n8n_credential_manager -out temp_build/n8n_credential_manager.enc -k "$ENCRYPT_KEY"

# Create a wrapper script that decrypts and runs
cat > temp_build/wrapper.sh << 'EOF'
#!/bin/sh
DIR=$(dirname "$0")
# Decrypt and execute with all arguments
openssl enc -aes-256-cbc -d -salt -in "$DIR/n8n_credential_manager.enc" -k "$DECRYPT_KEY" > "$DIR/n8n_credential_manager"
chmod +x "$DIR/n8n_credential_manager"
"$DIR/n8n_credential_manager" "$@"
rm -f "$DIR/n8n_credential_manager"
EOF

chmod +x temp_build/wrapper.sh

# Create the self-extracting archive
makeself temp_build/ n8n_credential_manager.run "N8N Credential Manager" ./wrapper.sh

# Cleanup
rm -rf temp_build build dist n8n_credential_manager.spec

echo -e "\nBuild complete! The executable is: n8n_credential_manager.run"
echo "Your encryption key is: $ENCRYPT_KEY"
echo "To run the encrypted executable:"
echo "DECRYPT_KEY='$ENCRYPT_KEY' ./n8n_credential_manager.run -- --url 'http://your-n8n-url:5678' --api-key 'your-api-key' --ollama-url 'http://your-ollama-url:11434' --creds-name 'Ollama account'"

chmod +x n8n_credential_manager.run