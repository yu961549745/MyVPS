apt clean all && apt autoremove -y && apt update --fix-missing && apt upgrade -y && apt dist-upgrade -y
apt install python-pip
pip install shadowsocks-py
wget https://raw.githubusercontent.com/yu961549745/MyVPS/master/single-user/start.sh   start.sh
wget https://raw.githubusercontent.com/yu961549745/MyVPS/master/single-user/stop.sh    stop.sh 
wget https://raw.githubusercontent.com/yu961549745/MyVPS/master/single-user/showlog.sh showlog.sh 
sh start.sh 