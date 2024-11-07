# source ./aliases.bash

function sops-edit() {
  SOPS_AGE_KEY=$(age -d ~/.ssh/jacq.age) sops edit --input-type dotenv --output-type dotenv ./.env.enc
}
