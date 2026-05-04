please guys do not forget to  
- configure aws using (source) '. ./aws-setup' then you can run terraform then ansible .
- to ssh to any master or worker use :          
ssh -i 'key' \
-o ProxyJump=ubuntu@'bastion-public-ip' \
ubuntu@'node-private-ip'

