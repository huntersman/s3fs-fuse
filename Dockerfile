FROM centos:7.4.1708

# 定义Dockerfile中CMD exec指令使用的ENV环境变量
ENV S3_BUCKET ''
ENV MNT_POINT /data
ENV S3_URL ''
ENV OPTION ''
ENV ACCESS_KEY ''
ENV SECRET_ACCESS_KEY ''

RUN yum -y update && \
yum install -y automake autotools-dev g++ git libcurl4-gnutls-dev wget \
libfuse-dev libssl-dev libxml2-dev make pkg-config && \
git clone https://github.com/huntersman/s3fs-fuse.git /tmp/s3fs-fuse && \
cd /tmp/s3fs-fuse && ./autogen.sh && ./configure && make && make install && \
ldconfig && /usr/local/bin/s3fs --version && \
mkdir -p "$MNT_POINT" && \
yum remove -y wget automake autotools-dev g++ git make && \
yum -y autoremove && yum clean all && \
rm -rf /var/cache/yum /tmp/* /var/tmp/*

CMD echo $ACCESS_KEY:$SECRET_ACCESS_KEY > ${HOME}/.passwd-s3fs && chmod 600 ${HOME}/.passwd-s3fs && exec /usr/local/bin/s3fs $S3_BUCKET $MNT_POINT -f -o passwd_file=${HOME}/.passwd-s3fs -o url=$S3_URL $OPTION