FROM ubuntu:16.04

MAINTAINER Thomas Buning "thomas.buning@rwth-aachen.de"

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update -qq

RUN echo 'Installing OS dependencies' && \
    apt-get install -qq -y --fix-missing sudo software-properties-common git unzip wget && \
    apt-get install openjdk-8-jdk -qq -y && \
    apt-get install gradle -qq -y

RUN echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN echo 'Creating user: developer' && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    sudo echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    sudo chmod 0440 /etc/sudoers.d/developer && \
    sudo chown developer:developer -R /home/developer && \
    sudo chown root:root /usr/bin/sudo && \
    chmod 4755 /usr/bin/sudo

RUN mkdir -p /home/developer/.IdeaIC2016.3/config/options && \
    mkdir -p /home/developer/.IdeaIC2016.3/config/plugins

ADD ./jdk.table.xml /home/developer/.IdeaIC2016.3/config/options/jdk.table.xml
ADD ./jdk.table.xml /home/developer/.jdk.table.xml

ADD ./pluginSetup /usr/local/bin/intellij

RUN chmod +x /usr/local/bin/intellij && \
    chown developer:developer -R /home/developer/.IdeaIC2016.3

RUN echo 'Downloading IntelliJ IDEA' && \
    wget https://download.jetbrains.com/idea/ideaIC-2016.3.tar.gz -O /tmp/intellij.tar.gz -q && \
    echo 'Installing IntelliJ IDEA' && \
    mkdir -p /opt/intellij && \
    tar -xf /tmp/intellij.tar.gz --strip-components=1 -C /opt/intellij && \
    rm /tmp/intellij.tar.gz

RUN echo 'Installing MSA plugin' && \
    cd /home/developer/.IdeaIC2016.3/config/plugins/ && \
    wget http://138.68.65.103:8081/artifactory/intellij_plugins_snapshot_local/de/monticore/lang/montisecarc/IntelliJ_Language_Plugin/0.8.10.SNAPSHOT/IntelliJ_Language_Plugin-0.8.0.SNAPSHOT.zip -O msa.zip -q && \
    unzip -q msa.zip && \
    rm msa.zip

RUN echo 'Installing GraphDatabase plugin' && \
    cd /home/developer/.IdeaIC2016.3/config/plugins/ && \
    wget http://138.68.65.103:8081/artifactory/intellij_plugins_snapshot_local/de/tbuning/neo4j/graphdatabase/GraphDatabasePlugin/1.0.0/GraphDatabasePlugin-1.0.0.zip -O GraphDatabasePlugin.zip -q && \
    unzip -q GraphDatabasePlugin.zip && \
    rm GraphDatabasePlugin.zip

RUN echo 'Installing Graph Database Support plugin' && \
    cd /home/developer/.IdeaIC2016.3/config/plugins/ && \
    wget https://plugins.jetbrains.com/files/8087/29684/GraphDatabaseSupport-2.2.0.zip -O graphdb.zip -q && \
    unzip -q graphdb.zip && \
    rm graphdb.zip

RUN sudo chown developer:developer -R /home/developer

USER developer
ENV HOME /home/developer
WORKDIR /home/developer/msa
CMD /usr/local/bin/intellij
