# ATPDocker
containerizing node.js apps with docker and Oracle Autonomous Database

Build docker images configured to run node.js apps on Oracle autonomous Databases.

To build a docker image, 

1. Clone repository to your local machine
2. Provision an Oracle Autonomous Transaction Processing (ATP) database in the Oracle Cloud. Download the credentials zip file
3. Unzip the database credentials zip file wallet_XXXXX.zip in
4. (Optional) Create db user 'nodeuser' and grant create session. Otherwise use an existing DB user.
4. Install docker on your local machine if it doesn't exist
5. build Dockerfile - $docker build -t aone .
6. Launch container mapping local port to 3050 -- $docker run -i -p 3050:3050 -t aone bash
7. Edit dbconfig.js to include information for your database (user/password/service)
8. Start the aone app  $ cd /opt/oracle/lib/ATPDocker/aone/
$ node server.js
9. Launch browser on local m/c and check out app at http://localhost:3050
