server=`python -m site --user-site`/shadowsocks/server.py
config_file=".ss.config.json"
if [ -f "$config_file" ]; then
    sudo python $server -c $config_file --log-file sslog.log -d start
    exit
else
    echo "config ss server ..."
fi
echo -n "port: "
read port
echo -n "password: "
read psw
echo "method: (aes-256-cfb | aes-256-cfb1 | aes-256-cfb8 | aes-256-ctr | rc4-md5)"
read method
echo "{
    \"server_port\": $port,
    \"password\": \"$psw\",
    \"method\": \"$method\"
}" > $config_file
sudo python $server -p $port -m $method -k $psw --log-file sslog.log -d start
echo "show server info by "
echo "              cat $config_file"
echo "reset server by "
echo "              rm $config_file && sh start.sh"
