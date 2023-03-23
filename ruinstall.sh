#Install required dependencies for R

sudo apt-get update
sudo apt-get install -y gdebi-core

#Install R

#install R and its dependencies.
#sudo apt-get install r-base

#or download a specific version of R
export R_VERSION=4.2.2
wget https://cdn.rstudio.com/r/ubuntu-2204/pkgs/r-${R_VERSION}_1_amd64.deb
sudo gdebi r-${R_VERSION}_1_amd64.deb

# #Install Rstudio server 
# wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.03.0-386-amd64.deb
# sudo gdebi rstudio-server-2023.03.0-386-amd64.deb

#Download and install Workbench:
sudo apt-get install gdebi-core
curl -O https://download2.rstudio.org/server/jammy/amd64/rstudio-workbench-2023.03.0-386.pro1-amd64.deb
sudo gdebi rstudio-workbench-2023.03.0-386.pro1-amd64.deb


#On installation:The Workbench configuration file (/etc/rstudio/rserver.conf) contains default configuration 
#to run Workbench using local launcher sessions, without SSL enabled, listening on port 8787.

#Verify R installation
/opt/R/${R_VERSION}/bin/R --version

#Create a symlink to R -- only for 1st installation, otherwise skip this step
sudo ln -s /opt/R/${R_VERSION}/bin/R /usr/local/bin/R
sudo ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/local/bin/Rscript

#Activate licence --check status
sudo rstudio-server license-manager status

