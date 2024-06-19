import smtplib

smtp_host = 'smtp.gmail.com'
smtp_port = 587
smtp_user = 'neupanesarika17@gmail.com'
smtp_password = 'tcro xmao oehy ggyf'

try:
    server = smtplib.SMTP(smtp_host, smtp_port)
    server.starttls()
    server.login(smtp_user, smtp_password)
    server.quit()
    print("SMTP connection successful")
except Exception as e:
    print(f"Failed to establish SMTP connection: {e}")
