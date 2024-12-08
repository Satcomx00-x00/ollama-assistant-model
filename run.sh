ollama pull nomic-embed-text:latest
ollama pull llama3.2:1b
ollama pull llama3.2:3b

ollama create assistant -f "assistant.modelfile"