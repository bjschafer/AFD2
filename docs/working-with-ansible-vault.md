# Working with Ansible Vault

[`ansible-vault`](https://docs.ansible.com/ansible/latest/user_guide/vault.html) is a way to manage encrypted data in a way that Ansible can natively understand. Because it's encrypted, it's okay to store it in a Git repo.

## How AFD2 uses `ansible-vault`

The Splunk repo should have a secret stored for the vault decryption key. This way, the key is not in source control and is only exposed to runners and users that we permit. This is passed as an environment variable to the runner, which echoes it into a `vault.pass` file in the Docker container it runs in. Since the container is discarded when finished, this is a reasonable approach.

The filename, `vault.pass` is special, but this is set in the `ansible.cfg` file.

## How you can use `ansible-vault`

First, ensure that your copy of the Splunk repo is in a secure location.

If you have just cloned your Splunk repo, please run `git submodule update --init --recursive` to ensure the AFD2 submodule is present in all its glory.

Next, inside your Splunk repo , create a file called `vault.pass`. Its only contents should be the Vault decryption key. The `vault.pass` file is in `.gitignore` so you can't accidentally commit it.

### Editing encrypted files

Run `ansible-vault edit filename.yml` from the AFD2 submodule directory. Assuming you've configured the `vault.pass` file above appropriately. it will automatically open the file in `$EDITOR` (probably either `nano` or `vim`). If you write and save it, it'll automatically reencrypt the file.

Still being prompted for the password?
* Make sure your working directory (i.e. `pwd`) is the _base_ of the Splunk repo.
* Ensure you have an `ansible.cfg` file. If you don't, run `ln -s afd2/ansible.cfg .`

### Using on Linux

Install Ansible via your package manager or `pip`. Further directions available [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). Follow the above directions.

### Using on Windows

This tool has not been thoroughly tested by us. If you have further directions or feedback, please contribute to this document!

You can use the [ansvaultcmd](http://www.chrisoldwood.com/dotnet/ansvaultcmd/ansvaultcmd.html) third-party tool. It's MIT licensed and the code is freely available on GitHub. You can also install it via Chocolatey by `choco install ansiblevaultcmd` in an elevated terminal.

You should be able to use it in PowerShell somewhat like this:

```powershell
AnsVaultCmd --infile secrets/prod.vault.yaml --password $(Get-Content .\vault.pass) --outfile secrets/prod.yaml
# edit secrets/prod.yaml
AnsVaultCmd --infile secrets/prod.yaml --password $(Get-Content .\vault.pass) --outfile secrets/prod.vault.yaml
Remove-Item secrets/prod.yaml
```
