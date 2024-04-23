# Nginx docker image

This is a project that contains the source code for the [webpanorg/nginx](https://hub.docker.com/r/webpanorg/nginx) image. It includes the original Dockerfile for building nginx with additional modules.
The Dockerfile includes a build of nginx with support for http3.

<p align="center">
    <table width="100%" style="max-width: 500px; margin: 0 auto">
    <tr >
        <td width="20%" valign="center">
            <a target="_blank" rel="noopener noreferrer" href="https://nginx.org/en/" alt="nginx">
                <img src="https://github.com/webpanorg/nginx/blob/assets/nginx.png?raw=true">
            </a>
        </td>
        <td width="20%" valign="center">
            <a target="_blank" rel="noopener noreferrer" href="https://en.wikipedia.org/wiki/HTTP/3" alt="http3">
                <img  src="https://github.com/webpanorg/nginx/blob/assets/http3.png?raw=true">
            </a>
        </td>
        <td width="20%" valign="center">
            <a target="_blank" rel="noopener noreferrer" href="https://nginx.org/en/docs/njs/index.html" alt="njs">
                <img src="https://github.com/webpanorg/nginx/blob/assets/njs.png?raw=true">
                <br />
                <!-- <span style="min-width: 120px">NJS</span> -->
            </a>
        </td>
        <td width="20%" valign="center">
            <a target="_blank" rel="noopener noreferrer" href="https://en.wikipedia.org/wiki/Brotli" alt="Brotli">
                <img src="https://github.com/webpanorg/nginx/blob/assets/brotli.png?raw=true">
            </a>
        </td>
    </tr>
    </table>
</p>


## How to use this image

Clone the repository to your machine. Modify the Dockerfile according to your needs. And create an image based on your Dockerfile.

```sh
docker build -t $name .
```