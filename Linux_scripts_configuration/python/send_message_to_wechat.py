#!/usr/bin/env python

import os
import json
import logging
from sys import argv
import requests as req

corpid = "#wwf05d6d6460f360c6"
corpsecret = "#9YX0uoLFqbtYJhFmZGBAzT9jMtKxVgHAuIz3jkrR2h0"
agentid = "1000002"
tokenUrl = "https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=" + corpid + \
            "&corpsecret=" + corpsecret

logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s:%(levelname)s:%(name)s:%(message)s',
                    datefmt="%a, %d %b %Y %H:%M:%S",
                    filename=os.path.join("./log", "wx_message.log"),
                    filemode='a')

def getToken(url):
    r = req.get(url)
    token_value = list(r.json().values())[2]
    return token_value

token = getToken(tokenUrl)
messageUrl = "https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=" + token


messageTo = argv[1]
subject = argv[2]
messageBody = argv[3]
# messageTo = "LiSuo"
# subject = "A message"
# messageBody = "Hello, Zabbix!"   # 消息内容

postBody = {
    "touser": messageTo,
    "msgtype": "text",
    "agentid": agentid,
    "text": {
        "content": messageBody
    },
    "safe": 0
}

def send_msg(url, p_body):
    post = req.post(messageUrl, data=json.dumps(p_body))

send_msg(messageUrl, postBody)
logging.info('messageTo:' + messageTo + ';;suject:' + subject + ';;msg:' + messageBody)
