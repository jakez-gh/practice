# practice

Public repository created from local workspace.

## Anthropic API Documentation

This repository includes a simple Anthropic API client and example usage for Claude.

Learn more from the official Anthropic Academy course:

- https://anthropic.skilljar.com/claude-with-the-anthropic-api/287725

### Getting started

Install the required packages:

```bash
%pip install anthropic python-dotenv
```

Create a `.env` file in the project root and add your API key:

```env
ANTHROPIC_API_KEY="your-api-key-here"
```

Make sure `.env` is ignored by Git.

### Loading the client

```python
from dotenv import load_dotenv
load_dotenv()

from anthropic import Anthropic

client = Anthropic()
model = "claude-sonnet-4-0"
```

### Making a request

Use `client.messages.create()` with the model, `max_tokens`, and a `messages` list:

```python
message = client.messages.create(
    model=model,
    max_tokens=1000,
    messages=[
        {
            "role": "user",
            "content": "What is quantum computing? Answer in one sentence"
        }
    ]
)
```

Extract the response text from `message.content[0].text`.

### Notes

- `max_tokens` is a safety limit, not a target.
- Messages are dictionaries with `role` and `content`.
- Use the `.env` file to keep your API key out of source control.

