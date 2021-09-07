#!/bin/bash

for ext in $(cat vscode_extensions);
do
    code --install-extension $ext;
done
