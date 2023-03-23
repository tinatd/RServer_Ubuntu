FROM ubuntu:jammy

LABEL maintainer="devel01@linitx.de"
LABEL version="0.1"
LABEL description="This is custom Docker Image for the Ubuntu with r-studio"

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Zurich

expose 8787
expose 22

ADD etc /etc

RUN apt-get update -q \
	&& apt-get upgrade -qy \
	&& apt-get install -qy  --no-install-recommends \
	apt-utils sudo supervisor vim openssh-server nano mc net-tools iproute2 iputils-ping
RUN mkdir /var/run/sshd


RUN addgroup wheel
RUN addgroup ssh
RUN useradd -ms /bin/bash rstudio -G users
RUN echo '-----------------muss noch raus------------------------>'
RUN echo 'rstudio:Docker!' | chpasswd
RUN echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config; \
    echo '<-----------------muss noch raus------------------------'
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		software-properties-common \
		dirmngr \
		ed \
		gpg-agent \
		less \
		locales \
		vim-tiny \
		wget \
		ca-certificates \
	&& wget -q -O - https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
		| tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc  \
	&& add-apt-repository --enable-source --yes "ppa:marutter/rrutter4.0" 
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

RUN	apt-get install -y \
		libhdf5-dev \
		libcurl4-gnutls-dev \
		libssl-dev \
		libxml2-dev \
		libpng-dev \
		libxt-dev \
		zlib1g-dev \
		libbz2-dev \
		liblzma-dev \
		libglpk40 \
		libgit2-dev \
		psmisc \
		libclang-dev \
		libpq5 \
		unixodbc-dev \
		unixodbc \
		unixodbc-dev \
		libaio1 \
		libsasl2-dev \
		gdebi-core 

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
        littler \
 		r-base \
 		r-base-dev \
 		r-recommended \
        r-cran-docopt \
  	&& ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
 	&& ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
 	&& ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
 	&& ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
  	&& ln -s /usr/lib/R/site-library/littler/examples/update.r /usr/local/bin/update.r \
 	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds 
 
RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2023.03.0-386-amd64.deb
RUN wget hhttps://download2.rstudio.org/server/jammy/amd64/rstudio-workbench-2023.03.0-386.pro1-amd64.deb
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1-1ubuntu2.1~18.04.21_amd64.deb
RUN wget https://cdn.rstudio.com/drivers/7C152C12/installer/rstudio-drivers_2022.11.0_amd64.deb
RUN dpkg -i  ./libssl1.1_1.1.1-1ubuntu2.1~18.04.21_amd64.deb 
RUN dpkg -i ./rstudio-server-2023.03.0-386-amd64.deb
RUN dpkg -i ./rstudio-workbench-2023.03.0-386.pro1-amd64.deb
RUN dpkg -i ./rstudio-drivers_2022.11.0_amd64.deb

# CMD ["bash"]
CMD ["/usr/bin/supervisord","-c","/etc/supervisord/supervisord.conf"]