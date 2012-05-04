#!/bin/sh
# Sets up this git repository for development

# 1. Init/Update submodules:
git submodule update --init --recursive

# 2. Install whitespace git hook for repository:
if [ -f ./Utilities/fix-whitespace.pre-commit.sh ]
then
    ln -fs ../../Utilities/fix-whitespace.pre-commit.sh .git/hooks/pre-commit
else
    echo '\nError: Fix whitespace script not found in repository.'
fi
