# Vault integration
The folling instructions are for edge modules that use edge-common. edige-sip2 is not included at this time within this branch. Instruction for using Vault as the secret store.

1. Helm install Vault ([Instructions](https://github.com/folio-org-priv/folio-infrastructure/tree/master/CI/hashicorp-vault))
2. Deploy edge module with `module-kubernetes` Role (Branch FOLIO-2641)
3. Create tenant and enable modules (`edge-rtac`)
4. Create Institutional User for Tenant
    * add permissions `rtac.all`
5. Use edge-common module to [create credentials](https://github.com/folio-org/edge-common#api-key-utilities)

        $ java -jar target/edge-common-api-key-utils.jar -g -s 20 -t diku -u diku
        <API Key>
        $ java -jar target/edge-common-api-key-utils.jar -p <API Key>
        Salt: <salt generated value>
        Tenant ID: diku
        Username: diku
6. Set up vault secret store with salt path

        $ ault secrets enable -path <salt generated value> kv
        
        
7. Vault CLI create secret for the vaules above (run wihtin Vault Container or Vault Client)

        $ vault kv put <salt generated value>/<tenant> <username>=<username>
        
8. Check Vault was created

        $ vault kv get  <salt generated value>/<tenant>
        $ vault kv get <salt generated value>/<tenant> | jq -r .data.data.<username>

7. [API key](https://github.com/folio-org/edge-common#api-key-sources) vault secret is present will allow activity. Institutional user has to have `rtac.all` permissions. This example was for edge-rtac, permissions will need to be updated for each edge module!

