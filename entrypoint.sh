#!/bin/sh -l

script_dir=$(dirname $0)

. "$script_dir/cloudflared.sh"
. "$script_dir/setup-ssh.sh"

app=$(echo $DOKKU_REPO | sed -e 's/.*\///')
echo "Parsed app name: $app"

echo "Pushing to Dokku Host"
command="git push $ssh_user@$ssh_host:$app refs/heads/$DEPLOY_BRANCH --force"
echo "git command: $command"

eval $command

[ $? -eq 0 ]  || exit 1

