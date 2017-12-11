FROM circleci/openjdk:8u151-jdk

# Install the Google Cloud SDK.
ENV HOME /home/circleci
ENV CLOUDSDK_PYTHON_SITEPACKAGES 1

RUN ls -al /usr/lib
RUN ls -al /usr/lib/google-cloud-sdk
RUN /usr/lib/google-cloud-sdk/bin/gcloud info
RUN /usr/lib/google-cloud-sdk/bin/gcloud components list

ENV PATH /opt/google-cloud-sdk/bin:$PATH
RUN echo ${PATH}

RUN curl -o /tmp/google-cloud-sdk.zip https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip
RUN sudo unzip -q -d /opt/. /tmp/google-cloud-sdk.zip
RUN rm /tmp/google-cloud-sdk.zip

RUN sudo /opt/google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app-engine-java app-engine-python kubectl alpha beta pubsub-emulator cloud-datastore-emulator

# Disable updater check for the whole installation.
# Users won't be bugged with notifications to update to the latest version of gcloud.
RUN sudo /opt/google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Disable updater completely.
# Running `gcloud components update` doesn't really do anything in a union FS.
# Changes are lost on a subsequent run.
RUN sudo sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /opt/google-cloud-sdk/lib/googlecloudsdk/core/config.json

CMD ["/bin/bash"]

RUN gcloud info
RUN gcloud components list
