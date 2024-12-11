ollama pull nomic-embed-text:latest
ollama pull llama3.2:3b
ollama pull llama3.3:70b

ollama create assistant -f "assistant.modelfile"