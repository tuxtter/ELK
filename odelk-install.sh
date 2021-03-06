#!/bin/sh
# This script install OpenDistro for Elasticsearch tested in a CentOS fresh installation.
curl https://d3g5vo6xdbdb9a.cloudfront.net/yum/opendistroforelasticsearch-artifacts.repo -o /etc/yum.repos.d/opendistroforelasticsearch-artifacts.repo
yum update
yum install -y java-1.8.0-openjdk-devel unzip elasticsearch-oss-6.5.4
yum install -y opendistroforelasticsearch opendistroforelasticsearch-kibana
ln -s /usr/lib/jvm/java-1.8.0/lib/tools.jar /usr/share/elasticsearch/lib/
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl enable kibana.service
service elasticsearch start
service kibana start
curl https://d3g5vo6xdbdb9a.cloudfront.net/downloads/perftop/perf-top-0.7.0.0-LINUX.zip -o $HOME/perf-top-0.7.0.0-LINUX.zip
unzip $HOME/perf-top-0.7.0.0-LINUX.zip
# Run this to view performance dashboards
#$HOME/perf-top-linux --dashboard $HOME/dashboards/ClusterOverview.json
sed -i "s/^enabled=1/enabled=0/" /etc/yum.repos.d/opendistroforelasticsearch-artifacts.repo
# Check cluster health
curl -XGET 'https://localhost:9200/_cluster/health?pretty=true' --insecure -u admin:admin
# Verify listening ports
netstat -tapn | grep LISTEN
