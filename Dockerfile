FROM ubuntu:19.10

# update base image and download required glibc libraries
RUN apt-get update && apt-get -y install libaio1  
#    ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1

#install node, git, python and cleanup cache
RUN apt-get  -y install  \
    nodejs \
    npm \
    git \
    python \
    unzip \
    vim
# get oracle instant client
ENV CLIENT_FILENAME instantclient-basic-linux.x64-19.3.0.0.0dbru.zip

# set working directory
WORKDIR /opt/oracle/lib

# Add instant client zip file
ADD ${CLIENT_FILENAME} .


# unzip required libs, unzip instant client and create sim links
RUN LIBS="libociei.so libnnz19.so libclntshcore.so.19.1 libclntsh.so.19.1" && \
    unzip ${CLIENT_FILENAME} && \
    cd instantclient_19_3 && \
    for lib in ${LIBS}; do cp ${lib} /usr/lib; done && \
    ln -s /usr/lib/libclntsh.so.19.1 /usr/lib/libclntsh.so 
    # rm ${CLIENT_FILENAME}

# get node app from git repo
RUN git clone https://github.com/melanieosc/ATPDocker.git
RUN mkdir wallet_NODEAPPDB2
COPY ./wallet_NODEAPPDB2 ./wallet_NODEAPPDB2

#set env variables
ENV ORACLE_BASE /opt/oracle/lib/instantclient_19_3
ENV LD_LIBRARY_PATH /opt/oracle/lib/instantclient_19_3
ENV TNS_ADMIN /opt/oracle/lib/wallet_NODEAPPDB2
ENV ORACLE_HOME /opt/oracle/lib/instantclient_19_3
ENV PATH /opt/oracle/lib/instantclient_19_3:/opt/oracle/lib/wallet_NODEAPPDB2:/opt/oracle/lib/ATPDocker/aone:/opt/oracle/lib/ATPDocker/aone/node_modules:$PATH
ENV force_colour_prompt=yes
ENV PS1="\e[36mDocker Container # \e[0m"
RUN echo ' PS1="\e[36mDocker Container # \e[0m"' >> /root/.bashrc
RUN cd /opt/oracle/lib/ATPDocker/aone && \
	npm install npm@latest -g && \
	npm install oracledb@3.1.2
EXPOSE 3050
#CMD [ "node", "/opt/oracle/lib/ATPDocker/aone/server.js" ]
