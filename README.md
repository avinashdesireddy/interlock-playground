# Interlock Debugging

## Update Interlock configuration
1. Find the current configuration
   ```
    CURRENT_CONFIG_NAME=$(docker service inspect --format '{{ (index .Spec.TaskTemplate.ContainerSpec.Configs 0).ConfigName }}' ucp-interlock)
    docker config inspect --format '{{ printf "%s" .Spec.Data }}' $CURRENT_CONFIG_NAME > config.orig.toml
    echo "CURRENT_CONFIG_NAME=${CURRENT_CONFIG_NAME}"
    ```
2. Make the necessary changes to the `config.orig.toml` file.
3. Create a new configuration object from the `config.orig.toml` file:
    ```
    NEW_CONFIG_NAME="com.docker.ucp.interlock.conf-$(( $(cut -d '-' -f 2 <<< "$CURRENT_CONFIG_NAME") + 1 ))"
    docker config create $NEW_CONFIG_NAME config.orig.toml
    ```
4. Update `ucp-interlock` service to start using the new configuration:
    ```
    docker service update \
    --config-rm $CURRENT_CONFIG_NAME \
    --config-add source=$NEW_CONFIG_NAME,target=/config.toml \
    ucp-interlock
    ```

## Download Interlock proxy(Nginx) config 
    ```
    docker config inspect --format '{{ printf "%s" .Spec.Data }}' $(docker service inspect --format '{{(index .Spec.TaskTemplate.ContainerSpec.Configs 0).ConfigName}}' ucp-interlock-proxy-amer) > interlock-nginx.conf
    ```

## Sample application
    - Use the compose files from `samples` directory

## Monitoring Nginx
    - Use `monitor_nginx.sh` script
    