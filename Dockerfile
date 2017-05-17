FROM ubuntu:16.04

# update system
RUN apt-get update
RUN apt-get -y upgrade
# install deps
RUN apt install -y curl make gcc g++ python binutils-gold gnupg

# configure key server for SHASUMS256 test
RUN gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys \
94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
FD3A5288F042B6850C66B31F09FE44734EB7990E \
71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
B9AE9905FFD7803F25714661B63B535A4C206CA9 \
56730D5401028683275BD23C23EFEFE93C4CFFFE

# configure node build
ENV VERSION="v4.8.3"

WORKDIR /home

# download node
RUN curl -sSLO https://nodejs.org/dist/${VERSION}/node-${VERSION}.tar.gz
RUN curl -sSL https://nodejs.org/dist/${VERSION}/SHASUMS256.txt.asc | gpg --batch --decrypt | grep " node-${VERSION}.tar.gz\$" | sha256sum -c | grep .

# install node
RUN tar -xzf node-${VERSION}.tar.gz
WORKDIR /home/node-${VERSION}
RUN ./configure
RUN make
RUN make install

RUN node -v
RUN npm -v