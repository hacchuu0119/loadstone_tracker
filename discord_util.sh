function discord_announce
{
json=$1

default_username=$(echo kagarinII)
#if [[ `ps aux | grep discordbot | wc | awk '{print $1}'`  < 2 ]];then

webhookurl=$2
# [[ -z $webhookurl ]] && webhookurl=$default_webhookurl
curl -H "Content-Type: application/json" -X POST --data $json $webhookurl
}
