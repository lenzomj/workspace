# Playbook

## Creating Vault

```bash
unset ANSIBLE_VAULT_PASSWORD_FILE
ansible-playbook --extra-vars "vault_keyfile=keyfile.keys" host-rekey-vault.yml
```

## Rotating Keys

```bash
unset ANSIBLE_VAULT_PASSWORD_FILE
ansible-playbook --extra-vars "vault_keyfile=keyfile.keys" host-rekey-vars.yml
```
