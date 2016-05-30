FROM deskor/xrdp
MAINTAINER Sven Dowideit <SvenDowideit@home.org.au> @SvenDowideit

# Update all the package references available for download
RUN apt-get update \
	&& apt-get install -yq \
		python-software-properties software-properties-common gcc-4.9 git make \
		wget curl unzip \
		libgtk2.0-0 libgconf-2-4 libasound2 libxtst6 libnss3 libnotify-bin

# Make sure to download newer version of node than what is the default in apt-get
RUN curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
RUN apt-get install -yq nodejs
#RUN apt-cache clean

# Install VSCode
#RUN wget -O $HOME/VSCode.zip 'https://az764295.vo.msecnd.net/public/0.10.3/VSCode-linux64.zip'
# https://go.microsoft.com/fwlink/?LinkID=620884
RUN wget -O $HOME/VSCode.zip 'https://go.microsoft.com/fwlink/?LinkID=620884'
#RUN unzip $HOME/VSCode.zip -d $HOME/vscode/
#RUN ln -s $HOME/vscode/VSCode-linux-x64/Code $HOME/bin/code
RUN unzip $HOME/VSCode.zip -d /opt \
	&& ln -s /opt/VSCode-linux-x64/code /usr/local/bin/code

# Switch to non-root user
#ENV USERNAME dockerx
#ENV HOME /home/$USERNAME
#
#USER $USERNAME
#RUN mkdir $HOME/bin
#ENV PATH $HOME/bin:$PATH
#
## Switch npm prefix to prevent using sudo.
#RUN mkdir $HOME/.npm-global
#ENV NPM_CONFIG_PREFIX $HOME/.npm-global
#ENV PATH $HOME/.npm-global/bin:$PATH
#
#
#USER root

# Install vsce, the Visual Studio Extension Manager
RUN npm install -g vsce
RUN npm --version \
	&& which vsce

# xrdp_sec_incoming: error reading /etc/xrdp/rsakeys.ini file
#RUN xrdp-keygen xrdp /etc/xrdp/rsakeys.ini

# OMG. https://github.com/Microsoft/vscode/issues/3451#issuecomment-199090068
RUN sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /usr/lib/x86_64-linux-gnu/libxcb.so.1

