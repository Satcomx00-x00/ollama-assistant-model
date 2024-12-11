import requests
import time
import argparse


def replace_credential(n8n_url, api_key, credential_name, ollama_url):
    base_endpoint = f"{n8n_url}/api/v1/credentials"
    headers = {"X-N8N-API-KEY": api_key, "Content-Type": "application/json"}

    # Get all credentials
    creds_response = requests.get(base_endpoint, headers=headers)
    creds_data = creds_response.json()

    print("Existing credentials:", creds_data)  # Debug print

    # Find credential with matching name
    cred_id = None
    if isinstance(creds_data, list):
        for cred in creds_data:
            if isinstance(cred, dict) and cred.get("name") == credential_name:
                cred_id = cred.get("id")
                break

    # Delete if found
    if cred_id:
        print(f"Deleting credential with ID: {cred_id}")
        delete_response = requests.delete(f"{base_endpoint}/{cred_id}", headers=headers)
        print("Delete response:", delete_response.json())
        time.sleep(1)

    # Create new
    data = {
        "name": credential_name,
        "type": "ollamaApi",
        "data": {"baseUrl": ollama_url},
        "nodesAccess": [
            {"nodeType": "n8n-nodes-base.ollama", "credential": "ollamaApi"}
        ],
    }

    create_response = requests.post(base_endpoint, headers=headers, json=data)
    print("Create response:", create_response.json())
    return create_response.json()


def main():
    parser = argparse.ArgumentParser(description="Update N8N Ollama credentials")
    parser.add_argument(
        "--url",
        type=str,
        required=True,
        help="N8N URL (e.g., http://192.168.1.86:5678)",
    )
    parser.add_argument("--api-key", type=str, required=True, help="N8N API key")
    parser.add_argument(
        "--ollama-url",
        type=str,
        required=True,
        help="Ollama URL (e.g., http://104.167.17.1:11434)",
    )
    parser.add_argument(
        "--creds-name",
        type=str,
        default="Ollama account",
        help='Credential name (default: "Ollama account")',
    )

    args = parser.parse_args()

    result = replace_credential(
        n8n_url=args.url,
        api_key=args.api_key,
        credential_name=args.creds_name,
        ollama_url=args.ollama_url,
    )


if __name__ == "__main__":
    main()


# python n8n_set_ollama_endpoint.py --url "http://192.168.1.86:5678" --api-key "n8n_api_330bbdce2819d8f9a7ec8d0863e34f3b522abcf11eb4d7e03818d49325d3d0f2975b7ed165d7ff70" --ollama-url "http://104.167.17.1:11434" --creds-name "Ollama account"
