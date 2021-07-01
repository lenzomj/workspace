# Playbook

## Creating Vault

```bash
unset ANSIBLE_VAULT_PASSWORD_FILE
ansible-playbook --vault-password-file=/path/to/keys.keys host-rekey-vault.yml
```

## Rotating Keys

```bash
unset ANSIBLE_VAULT_PASSWORD_FILE
ansible-playbook --vault-password-file=/path/to/keys.keys host-rekey-vars.yml    
```
