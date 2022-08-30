FROM --platform=linux/amd64 mambaorg/micromamba:latest

USER root

RUN apt-get update && \
    apt-get install -y git && \
    apt-get install -y wget
RUN wget https://sourceforge.net/projects/smina/files/smina.static/download -O smina && \
    chmod +x smina && \
    mv smina /usr/local/bin

USER $MAMBA_USER

COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yaml /tmp/env.yaml
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba install -c conda-forge -n base -y pdbfixer openbabel && \
    micromamba clean --all --yes
ARG MAMBA_DOCKERFILE_ACTIVATE=1

WORKDIR /molpal
COPY --chown=$MAMBA_USER:$MAMBA_USER . .

RUN pip install .
RUN pip install pyscreener

# ENTRYPOINT [ "molpal" ]
# CMD [ "run" ]