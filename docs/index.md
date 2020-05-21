# AFD2

## How to use

 `ansible-playbook main.yml -vv --force-handlers -i hosts/hosts_qa`

The `-vv` is optional and used mostly for debugging. `--force-handlers` is used to ensure configs are applied even if a step fails, so things aren't in a mixed state. TBD if it's a good idea.

### Dealing with the password

For local use at least, create a file called `vault.pass`. Its only contents should be the password. That file is in `.gitignore` so you shouldn't accidentally commit it. Then, it won't prompt for a password when running the playbook.

### Other notes

- You should copy `pre-commit.sh` to `.git/hooks/pre-commit`. It'll help prevent password oopsies. Or, even better -- symlink it with `cd .git/hooks && ln -s ../../pre-commit.sh pre-commit`. 
- Any files that are encrypted with vault should have the extension `.vault.yml`, instead of `.yml`.

### ssh keys

You need an ssh key in place. It must be added to the `.ssh/authorized_keys` file on any Splunk node this will be talking to.

### Adding apps to deploy

In your apps folder, create one `.yaml` file per app you'd like to deploy. It should contain something like this:

```yaml
app-name:
    branches:
      qa: git-ref-to-deploy-to-qa
      prod: git-ref-to-deploy-to-prod
    deployto:
      - shcluster # for things that should go to search head cluster
      - indexer   # for things that go to indexer cluster
      - forwarder # for things that need deployed using deploymentclient to forwarders
    serverclass:
      - Internal Heavy Forwarders # you can specify one or more serverclasses to associate with this app, if you're deploying to forwarders.
```

*Note*: many apps expect their folder name to be exactly what it is from Splunkbase. Take care not to rename your apps/repos lest you be burned by this.

### Adding indexes to deploy

In your indexes folder, create one `.yaml` file per index you'd like to create. It should contain something like this:

```yaml
index-name:
  name: index-name
  owner: User or team that "owns" this index
  description: |
  Multi-line block that describes what this index is for
```

## Repository structure

You should use this repository as a submodule of your actual config repo.

Your overall layout of repositories should look similar to this:

```
.
|-splunk/
|---apps/
|---hosts/
|---indexes/
|---secrets/
|---afd2 # submodule
|-afd2/
|-apps/ # group, not repo
|---shcluster/
|---TA-foo/
```
