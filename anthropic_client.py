import argparse
import sys

from dotenv import load_dotenv

load_dotenv()

from anthropic import Anthropic

client = Anthropic()
MODEL = "claude-opus-4-8"


def stream_response(messages: list) -> str:
    full_text = []
    with client.messages.stream(
        model=MODEL,
        max_tokens=16000,
        thinking={"type": "adaptive"},
        messages=messages,
    ) as stream:
        for text in stream.text_stream:
            print(text, end="", flush=True)
            full_text.append(text)
    print()
    return "".join(full_text)


def run_interactive():
    messages = []
    print(f"Claude CLI ({MODEL}) — type 'exit' or Ctrl+C to quit\n")
    while True:
        try:
            user_input = input("You: ").strip()
        except (EOFError, KeyboardInterrupt):
            print()
            break
        if not user_input or user_input.lower() == "exit":
            break
        messages.append({"role": "user", "content": user_input})
        print("Claude: ", end="")
        reply = stream_response(messages)
        messages.append({"role": "assistant", "content": reply})


def run_single(prompt: str):
    stream_response([{"role": "user", "content": prompt}])


def main():
    parser = argparse.ArgumentParser(description="Anthropic Claude CLI")
    parser.add_argument("prompt", nargs="?", help="Prompt to send (omit for interactive mode)")
    args = parser.parse_args()

    if args.prompt:
        run_single(args.prompt)
    elif not sys.stdin.isatty():
        run_single(sys.stdin.read().strip())
    else:
        run_interactive()


if __name__ == "__main__":
    main()
