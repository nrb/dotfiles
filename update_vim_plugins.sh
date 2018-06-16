#!/usr/bin/env bash
echo "Making sure submodules are initialized"
git submodule init
echo "Updating submodules based on latest remote changes"
git submodule update --remote --merge
