#!/usr/bin/env python3
# Edited by suosuoli.cn on 2020.03.17
# This script is created for getting elasticsearch cluster info

import smtplib
import subprocess
from email.utils import formataddr
from email.mime.text import MIMEText

false=""
IP="192.168.100.142"
body="curl -sXGET http://" + IP + ":9200/_cluster/health?pretty=true"
pro=subprocess.Popen((body),shell=True,stdout=subprocess.PIPE)
data=pro.stdout.read()
tmp=eval(data)
stat=tmp.get("status")
nu_nodes=tmp.get("number_of_nodes")
act_pri_shard=tmp.get("active_primary_shards")
act_shard=tmp.get("active_shards")
unassigned_shard=tmp.get("unassigned_shards")

print("                    集群状态：{}".format(stat))
print("                  集群节点数：{}".format(nu_nodes))
print("          集群中的主分片数量：{}".format(act_pri_shard))
print("          集群中的所有分片数：{}".format(act_shard))
print("集群状态中存在而找不到的分片：{}".format(unassigned_shard))
