echo "config ss server ..."
server=`python -m site --user-site`/shadowsocks/server.py
echo -n "port: "
read port
echo -n "password: "
read psw
echo "method: (aes-256-cfb | aes-256-cfb1 | aes-256-cfb8 | aes-256-ctr | rc4-md5)"
read method
sudo python $server -p $port -m $method -k $psw --log-file sslog.log -d start