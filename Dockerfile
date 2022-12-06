FROM alpine:3.17.0

ENV S3_BUCKET ''
ENV MNT_POINT /data
ENV S3_URL ''
ENV OPTION ''
ENV ACCESS_KEY ''
ENV SECRET_ACCESS_KEY ''

RUN apk --no-cache add ca-certificates automake g++ git libcurl wget alpine-sdk autoconf \
libxml2-dev make libressl-dev mailcap fuse-dev curl-dev && \
git clone https://github.com/huntersman/s3fs-fuse.git /tmp/s3fs-fuse && \
cd /tmp/s3fs-fuse && ./autogen.sh && ./configure && make && make install && \
/usr/local/bin/s3fs --version

VOLUME ["/data"]

CMD echo $ACCESS_KEY:$SECRET_ACCESS_KEY > ${HOME}/.passwd-s3fs && chmod 600 ${HOME}/.passwd-s3fs && exec /usr/local/bin/s3fs $S3_BUCKET $MNT_POINT -f -o passwd_file=${HOME}/.passwd-s3fs -o url=$S3_URL $OPTION