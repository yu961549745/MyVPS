# 环境安装
apt clean all && apt autoremove -y && apt update --fix-missing && apt upgrade -y && apt dist-upgrade -y
# git python
apt install git python python-setuptools python-pip build-essential ntpdate htop -y
# lnmp
apt install -y nginx mysql-server php7.0 php7.0-fpm php7.0-mysql php7.0-gd php7.0-mbstring php7.0-zip php7.0-curl
# 时区设置
dpkg-reconfigure tzdata

echo "------------ config sspanel ------------"
echo -n "app key (random set for security): "
read app_key
echo -n "app name: "
read app_name
echo -n "app url (http://domain.com): "
read app_url
echo -n "db ip (localhost): "
read db_ip
echo -n "db database: "
read db_name
echo -n "db username: "
read db_user
echo -n "db password: "
read db_password
echo -n "server node ID:"
read node_id

wget https://raw.githubusercontent.com/yu961549745/MyVPS/master/one-shell/strrep.py
root=`pwd`

# sspanel 安装
cd /var/www
git clone https://github.com/yu961549745/ss-panel-v3-mod_Uim.git sspanel
sudo chmod -R 777 /var/www 
cd sspanel
# 配置站点
cd config
cp .config.php.example .config.php 
python $root/strrep.py .config.php "$System_Config['key'] = '1145141919810'" "$System_Config['key'] = '$app_key'"  "$System_Config['appName'] = 'sspanel'" "$System_Config['appName'] = '$app_name'"   "$System_Config['baseUrl'] = 'http://url.com'" "$System_Config['baseUrl'] = '$app_url'"  "$System_Config['db_host'] = 'localhost'" "$System_Config['db_host'] = '$db_ip'"  "$System_Config['db_database'] = 'sspanel'" "$System_Config['db_database'] = '$db_name'"  "$System_Config['db_username'] = 'root'" "$System_Config['db_username'] = '$db_user'"  "$System_Config['db_password'] = 'sspanel'" "$System_Config['db_password'] = '$db_password'" 

cd ..
# 创建数据库
mysql -u$db_user -p$db_password -e "create database $db_name; use $db_name; source sql/glzjin_all.sql;"
# 安装依赖
php composer.phar install
# 创建管理员账号
php xcat createAdmin

# shadowsocks 后端安装
cd $root
echo "Installing libsodium..."
wget https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz
tar xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16
./configure && make -j2 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
cd ../ && rm -rf libsodium*
echo "Installing Shadowsocksr server from GitHub..."
mkdir /soft && cd /soft
git clone -b manyuser https://github.com/esdeathlove/shadowsocks.git
cd shadowsocks
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
echo "Generating config file..."
cp apiconfig.py userapiconfig.py
cp config.json user-config.json
python $root/strrep.py userapiconfig.py "'modwebapi'" "'glzjinmod'" "NODE_ID = 1" "NODE_ID = ${node_id}" "MYSQL_HOST = '127.0.0.1'" "MYSQL_HOST = '${db_ip}'" "MYSQL_USER = 'ss'" "MYSQL_USER = '${db_user}'" "MYSQL_PASS = 'ss'" "MYSQL_PASS = '${db_password}'" "MYSQL_DB = 'shadowsocks'" "MYSQL_DB = '${db_name}'"

# 配置和重启 Nginx
cd /etc/nginx/sites-available
wget https://raw.githubusercontent.com/yu961549745/MyVPS/master/one-shell/sspanel.conf -O sspanel
cd ../sites-enabled
rm -f default
ln -s ../sites-available/sspanel default
cd $root

# Google BBR 
echo -n "Do you want Google BBR (y/n): "
read use_bbr
if [[ $use_bbr == y ]]
then
wget https://github.com/teddysun/across/raw/master/bbr.sh && chmod +x bbr.sh && ./bbr.sh
else 
echo "no bbr"
fi

# 重启 nginx 
service nginx restart

# 后续步骤
echo "打开 $app_url 添加节点"
echo "sudo python /soft/shadowsocks/server.py 测试运行"
echo "sudo /soft/shadowsocks/run.sh 正式运行"
echo "校园网环境下 1025 端口貌似有问题, 建议新申请账号进行使用"
echo "而且总觉得 pannel 有问题, js 加载很慢"