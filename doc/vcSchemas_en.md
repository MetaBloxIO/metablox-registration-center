# VC Schemas

## Access Wi Fi network certificate

Field:

- type: optional values: user,validator,fisher
  - user (normal users who can access the network)
  - validator (the role of verifies the Wi Fi network)
  - fisher (bad Wi Fi miner (not for now))

## Mining machines manufacturer's certificate

The foundation issues certificates to certified manufacturers. Manufacturers issue certificates to their mining machines.

Field:

- name (manufacturer's name)
- email
- address (Token account address)

## Miner's certificate

Only miners who have a legal certificate issued by the manufacturer can participate in mining. The fields contained in the miner certificate are:

Field:

- name (manufacturer's name)
- model
- serial (serial number)
