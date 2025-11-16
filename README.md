# WordPress site CI/CD

This repo builds a Docker image containing your WordPress code and deploys it to the TSBI Docker Swarm via the CI pipeline.

## Secrets required for the GitHub Actions
- REGISTRY_USER: registry username
- REGISTRY_PASSWORD: registry password
- TSBI_HOST: VPS hostname or IP for SSH deploy
- TSBI_USER: username for SSH
- TSBI_SSH_KEY: private SSH key as GitHub secret with access to the above host

## How it works
- The workflow `wordpress-deploy.yml` builds an image from `Dockerfile`, tags it with the commit SHA and `latest`, and pushes to `registry.tsbi.fun`.
- On `main` branch push, the workflow connects to the DPS via SSH and runs:
  - `WP_TESTING_IMAGE=<IMAGE> docker stack deploy -c /data/ecosystem/deployments/wordpress/stack-wordpress.yml wordpress`
  - `docker service update --image <IMAGE> wordpress_wordpress-testing`

This updates the WordPress service to use the new image and routes traffic via Traefik. Traefik will issue TLS certificates as usual.

## Notes
- Keep `wp-config.php` out of the image; we'll store secrets on the VPS and mount volumes by using `bootstrap-wordpress-site.sh`.
- If you prefer to let the deploy script pick an image and generate stacks automatically, you can adapt the ecosystem's `deploy-from-registry.sh` script.
