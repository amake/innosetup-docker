FROM suchja/wine:latest
MAINTAINER Aaron Madlon-Kay <aaron@madlon-kay.com>

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends xvfb \
    && rm -rf /var/lib/apt/lists/*

# get at least error information from wine
ENV WINEDEBUG -all,err+all

# Run virtual X buffer on this port
ENV DISPLAY :99

COPY opt /opt
RUN chmod +x /opt/bin/*
ENV PATH $PATH:/opt/bin

# Install .NET Framework 4.0
USER xclient
# Dismiss .net, we only need innosetup
RUN wine wineboot --init \
		&& /scripts/waitonprocess.sh wineserver #\
#		&& winetricks --unattended dotnet40 dotnet_verifier \
#		&& /scripts/waitonprocess.sh wineserver

# Install Inno Setup binaries
RUN mkdir /home/xclient/inno \
		&& cd /home/xclient/inno \
		&& curl -SL "http://www.jrsoftware.org/download.php/is.exe" -o is.exe \
		&& wine is.exe /SILENT; exit 0  

