#!/bin/sh
SITE_DOMAINS="{% for domain in site_domains %}{{ domain }} {% endfor %}"
LOCAL_HOSTNAME=`curl http://169.254.169.254/latest/meta-data/local-hostname`
LOCAL_IPV4=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
PUBLIC_HOSTNAME=`curl http://169.254.169.254/latest/meta-data/public-hostname`
PUBLIC_IPV4=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
EC2_DOMAINS="$LOCAL_HOSTNAME $LOCAL_IPV4 $PUBLIC_HOSTNAME $PUBLIC_IPV4"
LOCALHOSTS="127.0.0.1 localhost"

sed -r -i "s/server_name .*localhost.*;/server_name $SITE_DOMAINS $EC2_DOMAINS $LOCALHOSTS;/" {{ nginx_conf }}
sed -r -i "s/^ALLOWED_HOSTS .*/ALLOWED_HOSTS = [{% for domain in site_domains %}'{{ domain }}',{% endfor %} '$LOCAL_HOSTNAME', '$LOCAL_IPV4', '$PUBLIC_HOSTNAME', '$PUBLIC_IPV4']/" {{ local_settings_py }}