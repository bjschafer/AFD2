# How to use

 `ansible-playbook main.yml -vv --force-handlers -i hosts/hosts_qa`

The `-vv` is optional and used mostly for debugging. `--force-handlers` is used to ensure configs are applied even if a step fails, so things aren't in a mixed state. TBD if it's a good idea.

## Dealing with the password

For local use at least, create a file called `vault.pass`. Its only contents should be the password. That file is in `.gitignore` so you shouldn't accidentally commit it. Then, it won't prompt for a password when running the playbook.

## Other notes

- You should copy `pre-commit.sh` to `.git/hooks/pre-commit`. It'll help prevent password oopsies. Or, even better -- symlink it with `cd .git/hooks && ln -s ../../pre-commit.sh pre-commit`. 
- Any files that are encrypted with vault should have the extension `.vault.yml`, instead of `.yml`.

## ssh keys

You need an ssh key in place. It must be added to the `.ssh/authorized_keys` file on any Splunk node this will be talking to.
