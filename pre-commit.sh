#!/bin/bash

. "$(git --exec-path)/git-sh-setup"

## REGION: TODO blocker
git diff-index -p -M --cached HEAD -- | grep '^+' |
	grep -Ei 'TODO|FIXME|XXX' && die Blocking commit because string TODO/FIXME/PDA detected in patch
: # this is a noop. dunno why it's here, but it does nothing ¯\_(ツ)_/¯
## ENDREGION: TODO blocker

## REGION: Secret blocker
if git rev-parse --verify HEAD >/dev/null 2>&1; then
	against=HEAD
else
	# Initial commit: diff against an empty tree object
	against=6548d2a825198b916b900d8f38192decca05149b
fi

# Redirect output to stderr.
exec 1>&2

EXIT_STATUS=0

# Check that all changed *.vault files are encrypted
# read: -r do not allow backslashes to escape characters; -d delimiter
while IFS= read -r -d $'\0' file; do
	[[ "$file" != *.vault && "$file" != *.vault.yml ]] && continue
	# cut gets symbols 1-2
	file_status=$(git status --porcelain -- "$file" 2>&1 | cut -c1-2)
	file_status_index=${file_status:0:1}
	file_status_worktree=${file_status:1:1}
	[[ "$file_status_worktree" != ' ' ]] && {
		echo "ERROR: *.vault file is modified in worktree but not added to the index: $file"
		echo "Can not check if it is properly encrypted. Use git add or git stash to fix this."
		EXIT_STATUS=1
	}
	# check is neither required nor possible for deleted files
	[[ "$file_status_index" == 'D' ]] && continue
	head -1 "$file" | grep --quiet '^\$ANSIBLE_VAULT;' || {
		echo "ERROR: non-encrypted *.vault file: $file"
		EXIT_STATUS=1
	}
done < <(git diff --cached --name-only -z "$against")

exit $EXIT_STATUS
## ENDREGION: Secret blocker
