#!/bin/bash

# Write the header
echo $'# dotfiles\n' > README.md

# Write the opening console block
echo '```console' >> README.md

# Append the tree output showing only files tracked by git
git ls-files | xargs ls -d 2>/dev/null | grep -v "README.md" | tree --fromfile -a >> README.md

# Write the closing console block
echo '```' >> README.md

# Add README.md to staging area if it has changes
git add README.md
