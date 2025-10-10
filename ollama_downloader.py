import json
import os
import requests
import shutil
import time
from pathlib import Path
from tqdm import tqdm


def list_available_models():
    """List all available models in Ollama."""
    try:
        response = requests.get("http://localhost:11434/api/tags")
        response.raise_for_status()
        return [model["name"] for model in response.json().get("models", [])]
    except Exception as e:
        print(f"❌ Error listing models: {str(e)}")
        return []

def download_model(model_name: str = "llama2", output_dir: str = "models"):
    """
    Download an Ollama model and save it locally.

    Args:
        model_name: Name of the model to download (default: "llama2")
        output_dir: Directory to save the model (default: "models")
    """
    # Check if Ollama is running
    try:
        requests.get("http://localhost:11434/", timeout=5)
    except (requests.exceptions.ConnectionError, requests.exceptions.Timeout):
        print("❌ Ollama is not running or not accessible. Please make sure Ollama is running with:")
        print("   ollama serve")
        print("\nIf you see 'address already in use', another instance might be running.")
        print("You can check with: lsof -i :11434")
        return False

    # List available models first
    print("🔍 Checking available models...")
    available_models = list_available_models()

    # Check if model is already available locally
    if any(model_name in model for model in available_models):
        print(f"✅ Model {model_name} is already available locally")
    else:
        print(f"⏳ Downloading {model_name}...")
        try:
            # Try pulling the model
            pull_response = requests.post(
                "http://localhost:11434/api/pull",
                json={"name": model_name, "stream": False},
                timeout=300  # 5 minutes timeout
            )
            pull_response.raise_for_status()
            print(f"✅ Successfully downloaded {model_name}")
        except requests.exceptions.HTTPError as e:
            if e.response.status_code == 404:
                print(f"❌ Model '{model_name}' not found in Ollama model registry")
                print("\nAvailable models:")
                for model in available_models:
                    print(f"  - {model}")
                print("\nTry one of these models or check the model name.")
                return False
            else:
                print(f"❌ Error downloading model: {str(e)}")
                return False
        except Exception as e:
            print(f"❌ Unexpected error: {str(e)}")
            return False

    # Now save the model files
    try:
        print("\n📦 Saving model files...")
        model_info = requests.get("http://localhost:11434/api/tags").json()
        model_details = next(
            (m for m in model_info.get("models", []) if model_name in m["name"]),
            None
        )

        if not model_details:
            raise ValueError(f"Model {model_name} not found in local Ollama models")

        model_path = save_model_locally(model_name, Path(output_dir), model_details)
        print(f"✅ Model saved to: {model_path}")
        return True

    except Exception as e:
        print(f"❌ Error saving model: {str(e)}")
        return False


def save_model_locally(model_name: str, output_dir: Path, model_details: dict) -> str:
    """Save the Ollama model files to the specified directory."""
    # Try multiple possible locations for the model files
    possible_paths = [
        Path.home() / ".ollama" / "models" / "blobs",
        Path.home() / ".ollama" / "models" / "manifests",
        Path.home() / ".ollama" / "models"
    ]

    # The model name might include a tag (e.g., "model:latest")
    model_base_name = model_name.split(":")[0]

    # Try to find the model files
    source_path = None
    for base_path in possible_paths:
        if not base_path.exists():
            continue

        # Look for directories that might contain the model
        for item in base_path.rglob("*"):
            if model_base_name.lower() in item.name.lower() or (
                    model_details.get("digest", "") and model_details["digest"] in item.name):
                if item.is_dir():
                    source_path = item
                    break
                elif item.is_file() and item.suffix in ('.bin', '.gguf', '.pth', '.safetensors'):
                    source_path = item.parent
                    break
        if source_path:
            break

    if not source_path:
        # If we still can't find it, try to get the exact path from Ollama
        try:
            model_info = requests.get(f"http://localhost:11434/api/show?name={model_name}").json()
            if "modelfile" in model_info:
                modelfile = model_info["modelfile"]
                if "path" in modelfile:
                    source_path = Path(modelfile["path"]).parent
        except:
            pass

    if not source_path or not source_path.exists():
        raise FileNotFoundError(
            f"Could not find model files for {model_name}. "
            f"Tried paths: {[str(p) for p in possible_paths]}"
        )

    # Create destination directory
    model_path = output_dir / model_base_name
    model_path.mkdir(parents=True, exist_ok=True)

    # Copy all files
    if source_path.is_file():
        shutil.copy2(source_path, model_path / source_path.name)
    else:
        for item in source_path.glob("*"):
            dest = model_path / item.name
            if item.is_file():
                shutil.copy2(item, dest)
            elif item.is_dir():
                shutil.copytree(item, dest, dirs_exist_ok=True)

    # Save model config
    config = {
        "model": model_name,
        "digest": model_details.get("digest", ""),
        "size": model_details.get("size", 0),
        "modified_at": model_details.get("modified_at", ""),
        "source_path": str(source_path)
    }

    with open(model_path / "config.json", "w") as f:
        json.dump(config, f, indent=2)

    return str(model_path)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Download and save an Ollama model locally")
    parser.add_argument(
        "--model",
        type=str,
        default="llama2",
        help="Name of the model to download (default: llama2)"
    )
    parser.add_argument(
        "--output-dir",
        type=str,
        default="models",
        help="Directory to save the model (default: models)"
    )
    parser.add_argument(
        "--list",
        action="store_true",
        help="List available models and exit"
    )

    args = parser.parse_args()

    if args.list:
        print("🔍 Available models:")
        models = list_available_models()
        if models:
            for model in models:
                print(f"  - {model}")
        else:
            print("No models found. Make sure Ollama is running and has models downloaded.")
        exit(0)

    if download_model(args.model, args.output_dir):
        print("\n✨ Model downloaded and saved successfully!")
    else:
        print("\n❌ Failed to download and save the model")
        exit(1)
