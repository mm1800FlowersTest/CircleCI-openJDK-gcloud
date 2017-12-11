FROM circleci/openjdk:8u151-jdk
#FROM gcr.io/google_appengine/base

# Prepare the image.
#ENV DEBIAN_FRONTEND noninteractive
#RUN apt-get update && apt-get install -y -qq --no-install-recommends wget unzip python php5-mysql php5-cli php5-cgi openjdk-7-jre-headless openssh-client python-openssl && apt-get clean

# Install the Google Cloud SDK.
ENV HOME /
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1

RUN echo ${PATH}

RUN ls -al
RUN ls -al /opt

ENV CLOUD_SDK_VERSION 181.0.0

ENV PATH /opt/google-cloud-sdk/bin:$PATH
#RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
#    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
#    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
#    ln -s /lib /lib64 && \
#    gcloud config set core/disable_usage_reporting true && \
#    gcloud config set component_manager/disable_update_check true && \
#    gcloud config set metrics/environment github_docker_image && \
#    gcloud --version

 
RUN curl -o /tmp/google-cloud-sdk.zip https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip
RUN ls -al /tmp
RUN sudo unzip -q -d /opt/. /tmp/google-cloud-sdk.zip
RUN rm /tmp/google-cloud-sdk.zip

#RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip
RUN ls -al /opt
#RUN unzip google-cloud-sdk.zip
#RUN rm google-cloud-sdk.zip
RUN sudo /opt/google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app-engine-java app-engine-python app kubectl alpha beta gcd-emulator pubsub-emulator cloud-datastore-emulator app-engine-go bigtable


# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN sudo /opt/google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Disable updater completely.
# Running `gcloud components update` doesn't really do anything in a union FS.
# Changes are lost on a subsequent run.
RUN sudo sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /opt/google-cloud-sdk/lib/googlecloudsdk/core/config.json

RUN cd /home/circleci
RUN gcloud info

#RUN mkdir /.ssh
#VOLUME ["/.config"]
#CMD ["/bin/bash"]