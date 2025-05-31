#! /bin/bash
# ollama pull nomic-embed-text:latest
# ollama pull llama3.2:3b
ollama pull qwen3:8b
ollama pull qwen2.5:7b
# ollama pull qwen3:8b  # This model doesn't exist, qwen3 is not available yet

# ollama create assistant -f "assistant.modelfile"
ollama create qwen2.5-translator -f "translator.modelfile"

# Also create a general purpose model for chat and analysis
ollama create qwen2.5-assistant -f "assistant.modelfile"