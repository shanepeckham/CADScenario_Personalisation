sudo apt-get -y update
echo "Install npm"
sudo apt-get -y install npm
echo "Installing node"
sudo apt-get -y install nodejs-legacy
sudo apt-get -y install -y nodejs
echo "Installing mysql-server"
sudo apt-get install -y debconf-utils
export DEBIAN_FRONTEND="noninteractive"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password MiniCAD123"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password MiniCAD123"
sudo apt-get install -y mysql-server
echo "Installing mysql client"
sudo apt-get -y install mysql-client
echo "Installing node mysql"  
npm install mysql
echo updating cnf
cd /etc/mysql
echo "Editing my.cnf"
sudo sed -i '$ a [mysqld]' my.cnf
sudo sed -i '$ a bind-address=10.1.0.4' my.cnf
echo "Restart mysql"
sudo -S service mysql restart 
echo installing git
sudo apt-get -y install git
echo "MySQL open remote access"
mysql -u root -pMiniCAD123 -e "use mysql; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' 
    IDENTIFIED BY 'MiniCAD123' 
    WITH GRANT OPTION;
FLUSH PRIVILEGES;"
echo "MySQL load"
mysql -u root -pMiniCAD123 -e "use mysql; CREATE TABLE IF NOT EXISTS customers (
  customerId INT(11) NOT NULL AUTO_INCREMENT,
  emailAddress VARCHAR(100) DEFAULT NULL,
  preferredLanguage VARCHAR(30) DEFAULT NULL,
  PRIMARY KEY (customerId)
) ENGINE=InnoDB; INSERT INTO customers (customerId, emailAddress, preferredLanguage) VALUES('1', 'bobby@turtlenecksweater.com', 'English');"
mysql -u root -pMiniCAD123 -e "use mysql; CREATE TABLE IF NOT EXISTS orders (
  orderId INT(11) NOT NULL AUTO_INCREMENT,
  customerId INT(11) NOT NULL,
  product VARCHAR(100) DEFAULT NULL,
  total VARCHAR(30) DEFAULT NULL,
  PRIMARY KEY (orderId)
) ENGINE=InnoDB; INSERT INTO orders (orderId, customerId, product, total) VALUES('1', '1', 'Latte', '$2.50');"
echo "Data loaded successfully"
echo "Getting Code"
netstat -plutn
