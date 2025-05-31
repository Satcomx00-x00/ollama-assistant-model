#! /bin/bash
# ollama pull nomic-embed-text:latest
# ollama pull llama3.2:3b
ollama pull qwen2.5:7b
ollama pull qwen3:7b

# ollama create assistant -f "assistant.modelfile"
ollama create qwen2.5-translator -f "translator.modelfile"