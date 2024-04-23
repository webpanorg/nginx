# Nginx docker image

This is a project that contains the source code for the [webpanorg/nginx](https://hub.docker.com/r/webpanorg/nginx) image. It includes the original Dockerfile for building nginx with additional modules.
The Dockerfile includes a build of nginx with support for http3.


<p align="center">
    <table width="100%" style="max-width: 400px; margin: 0 auto">
    <tr >
        <td valign="center" align="center">
            <a target="_blank" rel="noopener noreferrer" href="#">
                <img src="https://github.com/webpanorg/nginx/blob/assets/nginx.png?raw=true">
                <br />
                <span>NGINX</span>
            </a>
        </td>
        <td valign="center" align="center">
            <a target="_blank" rel="noopener noreferrer" href="#">
                <img  src="https://github.com/webpanorg/nginx/blob/assets/http3.png?raw=true">
                <br />
                <span>HTTP/3</span>
            </a>
        </td>
        <td valign="center" align="center">
            <a target="_blank" rel="noopener noreferrer" href="#">
                <img src="https://github.com/webpanorg/nginx/blob/assets/njs.png?raw=true">
                <br />
                <span>NJS</span>
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