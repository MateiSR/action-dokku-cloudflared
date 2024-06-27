#!/bin/sh -l

echo "Verifying Cloudflared Installation"
/usr/local/bin/cloudflared -v

if [ $? -ne 0 ]; then
  echo "Cloudflared is not installed"
  exit 1
fi

echo "Creating SSH config for Cloudflare Tunnel"
ssh_host=$(echo $DOKKU_REPO | sed -e 's/.*@//' -e 's/[:/].*//')
ssh_port=$(echo $DOKKU_REPO | sed -e 's/.*@//' -e 's/\/.*//' -ne 's/.*:\([0-9]*\)/\1/p')
ssh_user=$(echo $DOKKU_REPO | sed -e 's|ssh://\([^@]*\)@.*|\1|p')
echo "Extracted ssh_host: $ssh_host, ssh_port: $ssh_port, ssh_user: $ssh_user"

cat << EOF > /root/.ssh/config
User $ssh_user
Host $ssh_host
ProxyCommand /usr/local/bin/cloudflared access ssh --hostname %h --id $CLOUDFLARE_CLIENT_ID --secret $CLOUDFLARE_CLIENT_SECRET
IdentityFile /root/.ssh/id_rsa
StrictHostKeyChecking no
Port $ssh_port
EOF

echo "Created /root/.ssh/config"
