#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# --- Configuration ---
PYTHON_VERSION="3.12"      # Match your Lambda runtime version
TARGET_ARCH="aarch64"     # Use "aarch64" (ARM) or "x86_64" (Intel or AMD)
OUTPUT_ZIP="lambda_layer.zip"

echo "🚀 Starting automated Lambda Layer build..."

# 1. Clean up any old builds
rm -rf layer_build $OUTPUT_ZIP

# 2. Re-create the mandatory AWS layer folder structure
# AWS Lambda requires Python layer files to sit inside this exact path:
LAYER_DIR="layer_build/python/lib/python$PYTHON_VERSION/site-packages"
mkdir -p "$LAYER_DIR"

# 3. Export your current uv lockfile to a requirements.txt
echo "📦 Exporting uv.lock dependencies..."
uv export --frozen --no-dev --no-editable -o requirements.txt

# 4. Install dependencies directly into the layer directory
echo "⚡ Installing packages with uv..."
uv pip install \
  --no-installer-metadata \
  --no-compile-bytecode \
  --python-platform "${TARGET_ARCH}-manylinux2014" \
  --python "$PYTHON_VERSION" \
  --target "$LAYER_DIR" \
  -r requirements.txt

# 5. Package everything into a zip file
echo "🗜️ Zipping layer..."
cd layer_build
zip -rq "../$OUTPUT_ZIP" .
cd ..

# 6. Optional: Publish directly to AWS if you have the AWS CLI configured
# echo "☁️ Publishing layer to AWS..."
# aws lambda publish-layer-version \
#   --layer-name "my-uv-project-layer" \
#   --description "Dependencies managed by uv" \
#   --zip-file "fileb://$OUTPUT_ZIP" \
#   --compatible-runtimes "python$PYTHON_VERSION" \
#   --compatible-architectures "$TARGET_ARCH"

echo "✅ Layer successfully built at: $OUTPUT_ZIP"
