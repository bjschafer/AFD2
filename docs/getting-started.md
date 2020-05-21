## First time setup


### Manual app creation

1. Create a new Git repo following your structure
1. Add a deploy key.
1. Create a branch called prod, and make it the default branch. Apply protection so no one can push and maintainers can merge.
1. Delete the master branch
1. Create a branch called qa. Apply protection so developers & maintainers can push and merge. This prevents accidental deletion.

## Deploying

At the very least, you need to update the Splunk repo as appropriate. You should create a new branch off of QA, to make your merge easier. The filename should match the app's name. The file is entirely case-sensitive. The format is:

```yaml
app_name:
    branches:
      qa: # branch name to deploy to QA
      prod: # branch name to deploy to prod
    deployto: # this is a list, valid values are any combination of the following three
      - shcluster
      - forwarder
      - indexer
    serverclass: # if deployed to forwarders, the serverclass to associate with this app. must already exist.
      - Internal Heavy Forwarders
```

If you only want to deploy using the util server's deployer, `deployto` should only contain `forwarder`. You can set the serverclass as desired, then.

Create a MR once you've confirmed it works in QA.

## Adding an index

1. Find your Splunk repo
1. Navigate to the QA branch -> index folder.
1. Add a new file, yourindexname.yaml file and add your index. Follow the index naming schemes appropriately, and be sure to update the master list of indexes. The file should look like this:
```yaml
yourindexname:
  name: yourindexname
  owner: "User or Distro Group <email@example.com>"
  description: |
    This index is used for storing stuff and things.
    This description can be multiple lines.
```
1. Test in QA; it should deploy within 30 minutes.
1. Once it works, create a MR for QA -> master, and submit it for approval.
