FROM rstudio/r-base:3.6.3-bionic

ENTRYPOINT ["sh"]

RUN locale-gen en_US.UTF-8

# Install dotnet-sdk-3.1
RUN apt-get -y update && \
    apt-get -y install software-properties-common && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    apt-add-repository -y https://packages.microsoft.com/ubuntu/18.04/prod && \
    apt-get -y install dotnet-sdk-3.1 && \
    dotnet --version

# Install git, nuget and libraries
RUN apt-get -y install git nuget libcurl4-openssl-dev libssl-dev libxml2-dev openmpi-bin openmpi-common

# Install R package dependencies
RUN R --no-save -e "install.packages('R6', repos='http://cran.rstudio.com/')"

# Install mono
RUN apt-get -y install gnupg ca-certificates && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic/snapshots/5.18 main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt-get -y update && \
    apt-get -y install mono-complete

# Get software
ADD https://github.com/Open-Systems-Pharmacology/rClr/releases/download/v0.8.3_Linux/rClr_0.8.3_Ubuntu18.tar.gz /root/
ADD https://github.com/Open-Systems-Pharmacology/OSPSuite-R/releases/download/v9.1.4/ospsuite_9.1.4_ubuntu18.tar.gz /root/

# Install rClr and ospsuite
RUN R CMD INSTALL /root/rClr_0.8.3_Ubuntu18.tar.gz && \
    R CMD INSTALL /root/ospsuite_9.1.4_ubuntu18.tar.gz --install-tests

RUN rm -rf /root/rClr_0.8.3_Ubuntu18.tar.gz \
           /root/ospsuite_9.1.4_ubuntu18.tar.gz 

ENV LC_ALL en_US.UTF-8
ENV LD_LIBRARY_PATH="/usr/lib64/openmpi/lib:/opt/R/3.6.3/lib/R/library/ospsuite/lib:$LD_LIBRARY_PATH"
ENV PATH="/opt/R/3.6.3/bin:${PATH}"

# Simple test: run a population simulation
RUN R --no-save -e "library(ospsuite);setwd(system.file('extdata', package = 'ospsuite'));sim=loadSimulation('simple.pkml');pop=loadPopulation('simple_pop.csv');runSimulation(sim, pop)"

# Install testthat and run all package tests
# RUN R --no-save -e "install.packages('testthat', repos='http://cran.rstudio.com/')" 
# RUN R --no-save -e "setwd(system.file('tests', package = 'ospsuite')); source('testthat.R')" 
