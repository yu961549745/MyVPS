# 安装 docker
wget -qO- https://get.docker.com/ | sh
# 下载镜像
docker pull maxidea/ss-panel
# 运行镜像
docker run -d -P maxidea/ss-panel
docker ps 
echo -n "input container id:"
read container_id
# 创建管理员账号并重启服务
docker exec -i -t ${container_id} bash -c "cd /opt/ss-panel; php xcat createAdmin"
docker exec ${container_id} bash -c "supervisorctl restart shadowsocks; supervisorctl restart nginx"
# 保存镜像
docker commit ${container_id} maxidea/ss-panel
# 重启镜像并指定对外端口
docker run -d -p 80:80 -p 1025:1025 -p 1026:1026 -p 1027:1027 maxidea/ss-panel
# 去管理面板添加节点并使用
echo "go to http://your_ip_address_or_your_domian, and edit server nodes."
