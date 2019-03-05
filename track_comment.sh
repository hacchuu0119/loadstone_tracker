#!/usr/bin/env bash

for option in $@; do
  option_key=$(echo $option | sed -e 's/=.*//')
  option_value=$(echo $option | sed -e 's/^.*=//')
  case $option_key in
    target_url) target_url=$option_value ;;
    discord_url) discord_url=$option_value ;;
    last_response) last_response=$option_value ;;
    bk-server) bkname=$option_value ;;
    *) echo "[ERROR] i cant resolve option (option= $option_key) (value= $option_value)"
       exit 1
  esac
done

. $(pwd)/discord_util.sh
new_response=$(curl $target_url | grep 'thread__comment__body' -B 16 | tail -17 | grep -e 'img src' -e thread__comment__body -e entry__name)
new_comment_owner=$(echo $new_response | sed -e 's/^.*<p class="entry__name">//g' -e 's/<\/p>.*$//g' -e 's/ //g')
new_comment=$(echo $new_response | sed -e 's/^.*<div class="thread__comment__body">//g' -e 's/<br \/>/\\n/g' -e 's/<\/div>//g' -e 's/ //g')
new_commwnt_pic=$(echo $new_response | sed -e 's/<img src="//g' -e 's/" alt="".*$//g')
if [[ -n $(diff <(echo $new_comment) <( cat $last_response)) ]]; then
    echo $new_comment > $last_response
    json=$(printf '{"username":"%s","content":"新しいメッセージだよっ！","embeds":[{"author":{"name":"%s","icon_url":"%s"},"description":"%s","color":15792383,"fields":[{"name":"記事はこっちだよー","value":"%s","inline":true}]}]}' "kagari's" "$new_comment_owner" "$new_commwnt_pic" "$new_comment" "$target_url")
    discord_announce $(echo "${json} ${discord_url}")
fi
exit 0
