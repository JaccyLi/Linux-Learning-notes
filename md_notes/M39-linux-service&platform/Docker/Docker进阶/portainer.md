Portainer 基于 web 界面的 docker 开源管理程序：
Portainer 是一个开源和轻量级的 Docker 管理用户界面，基于调用 Docker API，可管理 Docker 容器，Portainer 可以创建删除容器、镜像上传下载和构建、数据卷管理、network 网络管理等。

    https://github.com/portainer/portainer #github
    https://www.portainer.io/ #官网

    官方部署文档：https://portainer.readthedocs.io/en/latest/deployment.html

    汉化项目：
    https://www.quchao.net/Portainer-CN.html


    docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /portainer:/data -v /opt/public:/public portainer/portainer


    docker开启远程端口管理：
    /usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375

    添加多host测试运行app
    172.31.6.103/linux39/nginx:1.16.1-alpine
