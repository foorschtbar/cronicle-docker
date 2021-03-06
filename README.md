# Cronicle Docker container

[
  ![](https://img.shields.io/docker/v/foorschtbar/cronicle?style=plastic)
  ![](https://img.shields.io/docker/pulls/foorschtbar/cronicle?style=plastic)
  ![](https://img.shields.io/docker/stars/foorschtbar/cronicle?style=plastic)
  ![](https://img.shields.io/docker/image-size/foorschtbar/cronicle?style=plastic)
  ![](https://img.shields.io/docker/cloud/build/foorschtbar/cronicle?style=plastic)
](https://hub.docker.com/repository/docker/foorschtbar/cronicle)
[
  ![](https://img.shields.io/github/last-commit/foorschtbar/cronicle-docker?style=plastic)
](https://github.com/foorschtbar/cronicle-docker)

Docker container for a Cronicle single-server master node

* GitHub: [foorschtbar/cronicle-docker](https://github.com/foorschtbar/cronicle-docker)
* Docker Hub: [foorschtbar/cronicle](https://hub.docker.com/r/foorschtbar/cronicle)

## Usage

### Example docker-compose configuration:

```yml
version: "3"

services:
  app:
    image: foorschtbar/cronicle:latest
    hostname: cronicle
    container_name: cronicle-app
    volumes:
      - ./data/data:/opt/cronicle/data
      - ./data/plugins:/opt/cronicle/plugins:ro
    environment:
      - CRONICLE_base_app_url=http://localhost:3012
      - CRONICLE_smtp_hostname=cronicle-mail
      - CRONICLE_email_from=<changeme>
    # - CRONICLE_web_direct_connect=1
    # - CRONICLE_socket_io_transports=polling
    restart: unless-stopped
    networks:
      - internal

  mail:
    image: bytemark/smtp
    restart: unless-stopped
    container_name: cronicle-mail
    environment:
      - MAILNAME=<changeme>
    networks:
      - internal

networks:
  internal:
    external: false
```


The web UI will be available at: http://localhost:3012

> NOTE: please replace the hostname `localhost`, this is only for testing
> purposes! If you rename the hostname also consider setting the environmental
> variable `CRONICLE_base_app_url`.
> e.g `docker run --name cronicle --hostname cronicle-host -p 3012:3012 -e CRONICLE_base_app_url='http://cronicle-host:3012' nicholasamorim/cronicle:latest`

## Volumes
Cronicle process runs under the `cronicle` user with `ID 1001` and `GUID `1001`.  If you are using Docker bind mounts set permissions accordingly.

| Path | Description |
|--------|--------|
| /opt/cronicle/data | Volume for data |
| /opt/cronicle/logs | Volume for logs |
| /opt/cronicle/plugins | Volume for plugins |

## Configuration

### Environmental variables
Cronicle supports a special environment variable syntax, which can specify command-line options as well as override any configuration settings.  The variable name syntax is `CRONICLE_key` where `key` is one of several command-line options (see table below) or a JSON configuration property path.

For overriding configuration properties by environment variable, you can specify any top-level JSON key from `config.json`, or a *path* to a nested property using double-underscore (`__`) as a path separator.  For boolean properties, you can specify `1` for true and `0` for false.  Here is an example of some of the possibilities available:

| Environmental variable | Description | Default value |
|--------|--------|--------|
| CRONICLE_base_app_url | A fully-qualified URL to Cronicle on your server, including the port if non-standard. This is used for self-referencing URLs. | http://localhost:3012 |
| CRONICLE_WebServer__http_port | The HTTP port for the web UI of your Cronicle server. (Keep default value, unless you know what you are doing) | 3012 |
| CRONICLE_WebServer__https_port | The SSL port for the web UI of your Cronicle server. (Keep default value, unless you know what you are doing) | 443 |
| CRONICLE_web_socket_use_hostnames | Setting this parameter to `1` will force Cronicle's Web UI to connect to the back-end servers using their hostnames rather than IP addresses. This includes both AJAX API calls and Websocket streams. | 1 |
| CRONICLE_server_comm_use_hostnames | Setting this parameter to `1` will force the Cronicle servers to connect to each other using hostnames rather than LAN IP addresses. | 1 |
| CRONICLE_web_direct_connect | When this property is set to `0`, the Cronicle Web UI will connect to whatever hostname/port is on the URL. It is expected that this hostname/port will always resolve to your master server. This is useful for single server setups, situations when your users do not have direct access to your Cronicle servers via their IPs or hostnames, or if you are running behind some kind of reverse proxy. If you set this parameter to `1`, then the Cronicle web application will connect directly to your individual Cronicle servers. This is more for multi-server configurations, especially when running behind a load balancer with multiple backup servers. The Web UI must always connect to the master server, so if you have multiple backup servers, it needs a direct connection. | 0 |
| CRONICLE_socket_io_transports | This allows you to customize the socket.io transports used to connect to the server for real-time updates. If you are trying to run Cronicle in an environment where WebSockets are not allowed (perhaps an ancient firewall or proxy), you can change this array to contain the `polling` transport first. Otherwise set it to `["websocket"]` | ["polling", "websocket"]

### Custom configuration file
A custom configuration file can be provide in the following location:
```sh
/path-to-cronicle-storage/data/config.json.import
```
The file will get loaded the very first time Cronicle is started. If afterwards
a forced reload of the custom configuration is needed remove the following file
and restart the Docker container:
```sh
/path-to-cronicle-storage/data/.setup_done
```

## Web UI credentials
The default credentials for the web interface are: `admin` / `admin`

# Reference
https://github.com/jhuckaby/Cronicle
