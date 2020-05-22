## Adding a whole new environment

Clone the AFD2 repository -- not the Splunk repo. Open hosts/hosts in your favorite editor.

You'll need to add a new environment below `qa`. 

!!! example
    hosts file with a new environment
    ```toml
    [prod]
    splunk-util.example.com
    splunk-index-master.example.com
    
    [qa]
    splunk-qa-util.example.com
    
    [staging]
    splunk-stage.example.com
    ```

Next, create a file in the `group_vars` folder named as your environment. Its contents should look like this:

!!! example
    new group_vars file:
    ```yml
    shcluster_bundle_target: https://splunk-search01.example.com:8089
    deployment_server: splunk-util.example.com:8089
    splunk_environment: prod
    splunk_environment_name: splunk
    ```

You can then push to your new environment with `ansible-playbook main.yml --limit your-env-name`

### Updating submodule reference

1. Clone the splunk config repo and run `git submodule update --recursive --init` to initialize the AFD2 submodule
2. Create a new branch matching your environment name with `git checkout -b your-env-name`
3. `cd` into `afd2` folder
4. `git checkout master` (or whatever branch your stuff is on in AFD2).
5. Commit and push as appropriate.

### Updating CI to push to your environment

1. Open `.gitlab-ci.yml` from the Splunk repo.
2. Copy one of the existing blocks and paste it at the bottom
3. Update the name to be meaningful
4. Update the `--limit` to point to your new environment name
5. Update `only` to include your branch name. (this is probably what you want).
6. Commit and push as appropriate.

### Adding environment

1. In the `.gitlab-ci.yml` file, change the environment name to something meaningful.
2. Change the `url` to point to your env's web interface.

### Adding secrets to deploy

Secrets are defined per-environment. You'll need to go into the vault file and either add new secrets or add your environment to existing secrets, as appropriate.

## Adding hosts to an existing environment

Clone the AFD2 repository -- not the Splunk repo. Open hosts/hosts in your favorite editor.

Each host will need to be added in at least two places: first, the environment (either `prod` or `qa`), and second, the role. It should be sufficient to simply put the FQDN of the host.

### On-host setup

You will need to configure the ssh public key on the node. On a default Splunk install, it goes in `~splunk/.ssh/authorized_keys`

