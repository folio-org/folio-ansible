# Vault integration
The folling instructions are for edge modules that use edge-common. edige-sip2 is not included at this time within this branch. Instruction for using Vault as the secret store.

1. Helm install Vault ([Instructions](https://github.com/hashicorp/vault-helm))
2. [Install Hashicorp Vault CLI](https://www.vaultproject.io/downloads) 
    1. Set ENV Varibles 
        * export VAULT_ADDR=< URL >
        * export VAULT_TOKEN=< hashicorp Vault Token >
        * export VAULT_FORMAT=json
2. Deploy edge module with `module-kubernetes` Role 
    1. Set Ansible Varibles (See defaults/main.yml)
        * edge_secure_store: Vault 
        * vault_token: < hashicorp Vault Token >
        * vault_addr: < http://< service name >.< namespace >.svc.cluster.local:8200 >
3. Create tenant and enable modules (`edge-rtac`)
4. Create Institutional User for Tenant
    * add permissions `rtac.all`
5. Set up vault secret store with salt path. Please change salt path(Use of human readable as part of salt for recognizable access `folio-iu-< salt >` to secret)

        $ vault secrets enable -path=folio-iu-< salt >/ kv
        # Example
        $ vault secrets enable -path=folio-iu-fdfdkfjk/ kv
        
        
6. Vault CLI create secret for the vaules above (run wihtin Vault Container or Vault Client)

        $ vault kv put folio-iu-< salt >/<tenant> <username>=<password>
        #Example
        $ vault kv put folio-iu-fdfdkfjk/diku edgeapi=mypassword
        
7. Check Vault was created

        $ vault kv get  <salt generated value>/<tenant>
        # Example 
        $ vault kv get folio-iu-fdfdkfjk/diku

8. [API key](https://github.com/folio-org/edge-common#api-key-sources) vault secret is present will allow activity. Institutional user has to have `rtac.all` permissions. This example was for edge-rtac, permissions will need to be updated for each edge module!

        # generate api key
        $ echo '{"s":"folio-iu-fdfdkfjk","t":"diku","u":"edgeapi"}' | base64
        eyJzIjoiZm9saW8taXUtZmRmZGtmamsiLCJ0IjoiZGlrdSIsInUiOiJlZGdlYXBpIn0K    

