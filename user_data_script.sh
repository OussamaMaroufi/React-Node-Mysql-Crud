#!/bin/bash -ex
# output user data logs into a separate file for debugging
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
# download nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
# source nvm
chmod +x ~/.nvm/nvm.sh
source ~/.bashrc

# install node

nvm install 16
nvm use 16

#upgrade yum
sudo yum upgrade
#install git
sudo yum install git -y
cd /home/ec2-user
# get source code from githubt
git clone https://github.com/OussamaMaroufi/React-Node-Mysql-Crud.git

#get in server dir
cd react-node-mysql-crud/server
#give permission
sudo chmod -R 755 .
#install node module
npm install
# start the app
npm run dev > app1.out.log 2> app1.err.log < /dev/null &

#get in client dir
cd ../client
#give permission
sudo chmod -R 755 .
#install node module
npm install
# start the app
npm run dev > app2.out.log 2> app2.err.log < /dev/null &

# to redirect traffic comes to port 80 into port 3001
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 3001