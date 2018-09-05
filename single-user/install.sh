apt clean all && apt autoremove -y && apt update --fix-missing && apt upgrade -y && apt dist-upgrade -y
apt install -y python-pip
pip install shadowsocks-py
wget https://raw.githubusercontent.com/yu961549745/MyVPS/master/single-user/start.sh  
wget https://raw.githubusercontent.com/yu961549745/MyVPS/master/single-user/stop.sh    
wget https://raw.githubusercontent.com/yu961549745/MyVPS/master/single-user/showlog.sh 
sh start.sh 