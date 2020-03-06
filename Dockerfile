FROM pwlb/rna-seq-pipeline-base:v0.1.1

#Gets miniconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.27-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH

#Gets the DropSeqPipe v0.41 from github
RUN git clone https://github.com/Hoohm/dropSeqPipe.git && \
    cd dropSeqPipe && \
    git checkout -b temp 4fc0de4b73588c22e2df78c9e0eae8b928d70e76

#Creates environment
COPY environment.yaml .
RUN conda env create -v --name dropSeqPipe --file environment.yaml

RUN pip3 install pandas
RUN pip3 install ftputil

COPY ./binaries/gtfToGenePred /usr/bin/gtfToGenePred

#Defines environment variables
ENV TARGETS "all"
ENV SAMPLENAMES ""

#Copies needed files and directories into container
COPY example/config.yaml /config/
COPY scripts /scripts
COPY /templates /templates

RUN echo "" >> /dropSeqPipe/Snakefile

ENTRYPOINT ["/bin/bash"]

#Executes run-all.sh
CMD ["/scripts/run-all.sh"]
