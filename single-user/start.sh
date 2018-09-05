server=ssserver
config_file="ss.config.json"
if [ -f "$config_file" ]; then
    sudo $server -c $config_file --log-file sslog.log -d start
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
sudo $server -p $port -m $method -k $psw --log-file sslog.log -d start
echo "show server info by "
echo "              cat $config_file"
echo "reset and start server by "
echo "              rm -f $config_file && sh start.sh"
echo "start server by this config"
echo "              sh start.sh"
