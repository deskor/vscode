FROM deskor/vscode:latest
MAINTAINER Sven Dowideit <SvenDowideit@home.org.au> @SvenDowideit

# legacy of the work Sven did in 2013
# TODO: remove
ENV USERNAME dockerx
ENV HOME /home/$USERNAME

# Update all the package references available for download
RUN apt-get update \
	&& apt-get install -yq \
	python-software-properties software-properties-common gcc-4.9 git make wget \
	libgtk2.0-0 \
	libgconf-2-4 \
	libasound2 \
	libxtst6 \
	libnss3 \
	libnotify-bin

# Switch to non-root user
USER $USERNAME
RUN mkdir $HOME/bin
ENV PATH $HOME/bin:$PATH

# Go-specific instructions.
# Reference link: https://golang.org/dl/
ENV GOLANG 1.6.2
RUN wget https://storage.googleapis.com/golang/go${GOLANG}.linux-amd64.tar.gz -O $HOME/go.tar.gz
RUN mkdir $HOME/go && tar -C $HOME -xzf $HOME/go.tar.gz && rm $HOME/go.tar.gz
RUN ln -s $HOME/go/bin/go $HOME/bin/go

# Set the gopath
RUN mkdir -p $HOME/project/src
ENV GOPATH $HOME/project
ENV GOROOT $HOME/go

# Install tools
# TODO: addded ||true because 29-may-2016, things were failing to build
RUN go get -u -v github.com/nsf/gocode github.com/rogpeppe/godef github.com/golang/lint/golint github.com/lukehoban/go-find-references sourcegraph.com/sqs/goreturns golang.org/x/tools/cmd/gorename || true

# Install the debugger
ENV GO15VENDOREXPERIMENT 1
RUN git clone https://github.com/derekparker/delve.git $GOPATH/src/github.com/derekparker/delve
#RUN cd $GOPATH/src/github.com/derekparker/delve && git checkout v0.11.0-alpha && make install
RUN cd $GOPATH/src/github.com/derekparker/delve && make install

# Preserve the PATH because when we run `su $USERNAME`, PATH would have been reset.
# Part of workaround discussed in entry.sh
RUN echo "export PATH=$PATH:$GOPATH/bin" >> $HOME/.bashrc

# Remove all files in the src folder to clean up
RUN rm -rf $GOPATH/src/*

# Set the workspace
WORKDIR $GOPATH
#USER root
# Add the entrypoint script
#ADD entry.sh $HOME/bin/entry.sh
#RUN chmod +x $HOME/bin/entry.sh
USER $USERNAME

#ENTRYPOINT "$HOME/bin/entry.sh"
#FROM base-gdec-gui
#MAINTAINER James C. Scott III <jcscott.iii@gmail.com>

USER $USERNAME

# Install the vscode-go extension
RUN git clone https://github.com/Microsoft/vscode-go $HOME/.vscode/extensions/lukehoban.Go
RUN cd $HOME/.vscode/extensions/lukehoban.Go \
	&& git checkout tags/0.6.30
RUN cd $HOME/.vscode/extensions/lukehoban.Go \
	&& npm install
#RUN cd $HOME/.vscode/extensions/lukehoban.Go \
#	&& chmod 755 ./node_modules/vscode/bin/compile \
#	&& vsce package

# Add settings.json file that contains settings for the go extension
RUN mkdir -p $HOME/.config/Code/User/
ADD settings.json $HOME/.config/Code/User/settings.json

# Move back to root for the su in entry.sh
USER root

# chown the settings.json file to the non-root user
RUN chown -R $USERNAME:$USERNAME $HOME/.config/Code/User/settings.json


