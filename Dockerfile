FROM lsiobase/xenial.arm64
MAINTAINER sparklyballs

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config/xdg"

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# install packages
RUN \
 apt-get update && \
 apt-get install -y \
	libcurl3 \
	libmono-cil-dev \
	mediainfo && \

# install radarr
 radarr_tag=$(curl -sX GET "https://api.github.com/repos/Radarr/Radarr/releases" \
	| awk '/tag_name/{print $4;exit}' FS='[""]') && \
 radarr_ver="${radarr_tag#v}" && \
 mkdir -p \
	/opt/radarr && \
 curl -o \
 /tmp/radar.tar.gz -L \
	"https://github.com/galli-leo/Radarr/releases/download/${radarr_tag}/Radarr.develop.${radarr_ver}.linux.tar.gz" && \
 tar xf \
 /tmp/radar.tar.gz -C \
	/opt/radarr --strip-components=1 && \

# clean up
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 7878
VOLUME /config /downloads /movies