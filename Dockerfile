FROM node

# Install redis
RUN apt-get update && apt-get install -y tcl8.5 && wget http://download.redis.io/releases/redis-stable.tar.gz && tar xzf redis-stable.tar.gz && cd redis-stable/ && make && make test && make install && utils/install_server.sh 

# Install zclassic node
RUN useradd -ms /bin/bash zcluser
WORKDIR /home/zcluser
RUN apt-get install -y apt-utils libleveldb1 libleveldb-dev build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git python zlib1g-dev wget bsdmainutils automake
RUN git clone https://github.com/z-classic/zclassic
RUN /home/zcluser/zclassic/zcutil/build.sh

# Get zclassic.conf
RUN mkdir /home/zcluser/.zclassic /home/zcluser/database

# Fetch Z parameters
USER zcluser
RUN /home/zcluser/zclassic/zcutil/fetch-params.sh && chown -R zcluser:zcluser /home/zcluser/.zcash-params/

# Install node dependencies
USER root
RUN apt-get install -y build-essential libsodium-dev npm vim net-tools sudo
RUN npm install n -g && n stable

COPY run_zclassic_node.sh /home/zcluser/run_zclassic_node.sh
RUN chown zcluser:zcluser /home/zcluser/.zclassic/ /home/zcluser/run_zclassic_node.sh
RUN chown zcluser:zcluser /home/zcluser/zclassic
RUN chmod +x /home/zcluser/run_zclassic_node.sh

COPY z-nomp-config.json /home/zcluser/config.json
COPY zclassic.json /home/zcluser/zclassic-template.json
COPY run_zcl_nomp.sh /home/zcluser/run_zcl_nomp.sh
