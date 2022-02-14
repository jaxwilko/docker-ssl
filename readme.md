# SSL Generation - Docker

This project aims to provide a simple and consistent ssl generation.

## Install

```shell
# Generate your own SSL
docker run -it --rm -v $(pwd):/app -w /app nginx:latest /app/generate.sh example.com
```

Add your SSL to your CA certificates (for linux use the following, for other platforms see: [manuals.gfi.com](https://manuals.gfi.com/en/kerio/connect/content/server-configuration/ssl-certificates/adding-trusted-root-certificates-to-the-server-1605.html)).

```shell
sudo cp root/ca.pem /usr/local/share/ca-certificates/MY_ORG_NAME.crt
sudo chmod 644 /usr/local/share/ca-certificates/MY_ORG_NAME.crt
sudo update-ca-certificates
```

> Chrome may require you to manually add the CA cert manually.
