#!/bin/bash

# Write the header
echo $'# dotfiles\n' > README.md

# Write the opening console block
echo '```console' >> README.md

# Append the tree output
tree -a -I ".git|.update.sh|.pre-commit-config.yaml|README.md" . >> README.md

# Write the closing console block
echo '```' >> README.md

# Add README.md to staging area if it has changes
git add README.md
