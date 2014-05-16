# -*- coding: utf-8 -*-
##
#toaddr = 'buffy@sunnydale.k12.ca.us'
#cc = ['alexander@sunydale.k12.ca.us','willow@sunnydale.k12.ca.us']
#bcc = ['chairman@slayerscouncil.uk']
#fromaddr = 'giles@sunnydale.k12.ca.us'
#message_subject = "disturbance in sector 7"
#message_text = "Three are dead in an attack in the sewers below sector 7."
#message = "Subject %s\r\n" % message_subject
		 #+"From: %s\r\n" % fromaddr
		 #+"To: %s\r\n" % toaddr
		 #+"CC: %s\r\n" % ",".join(cc)
		 #+"Subject: %s\r\n" % message_subject
		 #+"\r\n" + message_text
#toaddrs = [toaddr] + cc + bcc
#server = smtplib.SMTP('smtp.sunnydale.k12.ca.us')
#server.set_debuglevel(1)
#server.sendmail(fromaddr, toaddrs, message)
#server.quit()


import smtplib
from email.mime.text import MIMEText
from email.MIMEMultipart import MIMEMultipart
import datetime
import time


TODAY = datetime.date.today()
CURRENTDAY=TODAY.strftime('%Y%m%d')
def sendattachmail ():
	msg = MIMEMultipart()
	#att = MIMEText(open(r'', 'rb').read(), 'base64', 'utf-8') #设置附件的目录
	#att['content-type'] = 'application/octet-stream'
	#att['content-disposition'] = 'attachment;filename="IMD_EBM.xlsx"' #设置附件的名称
	#msg.attach(att)

	content = 'The sever is working well. 是不' #正文内容
	body = MIMEText(content,'plain','utf-8') #设置字符编码
	msg.attach(body)

	msgto = ['zhangguangde@cgmobile.com.cn'] # 收件人地址 多个联系人，格式是['aa@163.com'; 'bb@163.com']
	msgfrom = 'zhangguangde@cgmobile.com.cn' # 寄信人地址 ,
	msg['subject'] = '服务器状态查询_'+CURRENTDAY  #主题
	msg['date']=time.ctime() #时间
	msg['Cc']='xuyouqin@cgmobile.com.cn' #抄送人地址 多个地址不起作用

	mailuser = 'zhangguangde@cgmobile.com.cn'  # 用户名
	mailpwd = '870260Dangic' #密码

	try:
		smtp = smtplib.SMTP()
		smtp.connect(r'smtp.cgmobile.com.cn')# smtp设置
		smtp.login(mailuser, mailpwd) #登录
		smtp.sendmail(msgfrom, msgto, msg.as_string()) #发送
		smtp.close()
	except Exception, e:
		print e


if __name__ == '__main__':
	sendattachmail()
