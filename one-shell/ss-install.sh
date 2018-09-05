# 环境安装
apt clean all && apt autoremove -y && apt update --fix-missing && apt upgrade -y && apt dist-upgrade -y
# git python
apt install git python-setuptools python-pip build-essential ntpdate htop -y
# lnmp
apt install -y nginx mysql-server php7.0 php7.0-fpm php7.0-mysql php7.0-gd php7.0-mbstring php7.0-zip 
# 时区设置
dpkg-reconfigure tzdata

# sspanel 安装
cd /var/www
chmod -R 777 .
git clone https://github.com/yu961549745/ss-panel-v3-mod_Uim.git sspanel
cd sspanel

# 配置站点
cd config
cp .config.php.example .config.php 
echo "------------ config sspanel ------------"
echo -n "app key (random set for security): "
read app_key
echo -n "app name: "
read app_name
echo -n "app url: "
read app_url
echo -n "db host: "
read db_host
echo -n "db database: "
read db_database
echo -n "db username: "
read db_username
echo -n "db password: "
read db_password
sed -i -e "s/$System_Config['key'] = '1145141919810';/$System_Config['key'] = '${app_key}';/g"

echo "Installing libsodium..."
wget https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz
tar xf libsodium-1.0.16.tar.gz && cd libsodium-1.0.16
./configure && make -j2 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
cd ../ && rm -rf libsodium*

# shadowsocks 后端安装
echo "Installing Shadowsocksr server from GitHub..."
mkdir /soft && cd /soft
git clone -b manyuser https://github.com/esdeathlove/shadowsocks.git
cd shadowsocks
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
echo "Generating config file..."
cp apiconfig.py userapiconfig.py
cp config.json user-config.json
sed -i -e "s/'modwebapi'/'glzjinmod'/g" userapiconfig.py
echo -n "Please enter database server's IP address:"
read db_ip
echo -n "DB name:"
read db_name
echo -n "DB username:"
read db_user
echo -n "DB password:"
read db_password
echo -n "Server node ID:"
read node_id
echo "Writting config..."
sed -i -e "s/NODE_ID = 1/NODE_ID = ${node_id}/g" -e "s/MYSQL_HOST = '127.0.0.1'/MYSQL_HOST = '${db_ip}'/g" -e "s/MYSQL_USER = 'ss'/MYSQL_USER = '${db_user}'/g" -e "s/MYSQL_PASS = 'ss'/MYSQL_PASS = '${db_password}'/g" -e "s/MYSQL_DB = 'shadowsocks'/MYSQL_DB = '${db_name}'/g" userapiconfig.py
echo "Running system optimization and