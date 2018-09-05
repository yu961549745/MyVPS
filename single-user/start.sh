echo "config ss server ..."
server=`python -m site --user-site`/shadowsocks/server.py
echo "port: "
read port
echo "method: (aes-256-cfb)" 
read method
echo "password: "
read psw
sudo python $server -p $port -m $method -k $psw --log-file sslog.log -d start 