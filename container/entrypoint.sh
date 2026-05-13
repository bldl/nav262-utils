#!/bin/bash
VERSION=$1

if [ -z "$VERSION" ]; then
  echo "Error: VERSION parameter is required."
  exit 1
fi

echo "Extracting target: $VERSION"
# Extract ASTs
cd /esmeta
esmeta extract -extract:log -extract:target="$VERSION"

# Generate biblio.json
cd /esmeta/ecma262
git checkout $VERSION # Checkout the specific version of the spec to ensure we get the correct biblio.json
export PUPPETEER_SKIP_DOWNLOAD=true # Skip Puppeteer download since we won't use it in this context. Also avoid install process hanging.
npm install
npx ecmarkup --verbose spec.html --write-biblio biblio/biblio.json /dev/null

# Normalize ASTs
cd /nav262-utils/spec-manipulator
SEF_FILES=$(find src/sef -name "*.sef.json" -type f | sort)
SEF_FLAGS=$(echo "$SEF_FILES" | xargs -I {} echo -n "-x {} ")
npm run start -- -e sdo -i "$ESMETA_HOME"/logs/extract/algos_json -o ast -b "$ESMETA_HOME"/ecma262/biblio/biblio.json $SEF_FLAGS

XML_COUNT=$(find "ast" -type f -name "*.xml" | wc -l)
echo "Extracted ASTs: $XML_COUNT"
