FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

# Install apt-getable dependencies
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cmake \
        git \
        libcurl4-openssl-dev \
        libssl-dev \
        libgdal-dev

RUN git clone https://github.com/PDAL/PDAL.git && cd PDAL && git checkout 2.8.4
RUN cp /usr/include/gdal/cpl_*.h /usr/include
RUN cd PDAL && mkdir build && cd build && cmake .. && make -j6 && make install

COPY . /entwine

RUN cd entwine && mkdir build && cd build && cmake .. && make -j6
RUN ctest

WORKDIR /entwine
