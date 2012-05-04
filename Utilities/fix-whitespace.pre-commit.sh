#!/bin/sh
# Pre-commit hook for git which removes trailing whitespace and converts tabs to spaces.

if git-rev-parse --verify HEAD >/dev/null 2>&1 ; then
   against=HEAD
else
   # Initial commit: diff against an empty tree object
   against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

FILES_WITH_WHITESPACE=`git diff-index --check --cached $against | # Find all changed files
                       sed '/^[+-]/d' |                           # Remove lines which start with + or - 
                       sed -E 's/:[0-9]+:.*//' |                  # Remove end of lines which contains numbers, etc.
                       sed '/Generated/d' |                       # Ignore generated files
                       sed '/\.[mh]\$/!d' |                       # Only process .m and .h files
                       uniq`                                      # Remove duplicate files


# Change field seperator to newline so that for correctly iterates over lines
IFS=$'\n'

# Find files with trailing whitespace
for FILE in $FILES_WITH_WHITESPACE ; do
    echo "Fixing whitespace in $FILE" >&2
    # Replace tabs with four spaces
    sed -i "" $'s/\t/    /g' "$FILE"
    # Strip trailing whitespace
    sed -i '' -E 's/[[:space:]]*$//' "$FILE"
    git add "$FILE"
done
