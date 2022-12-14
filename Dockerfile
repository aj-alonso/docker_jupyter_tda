FROM jupyter/scipy-notebook

USER root

RUN apt-get update --yes && apt-get install --yes \
    build-essential \
    cmake \
    libeigen3-dev \
    libgmp-dev \
    libgmpxx4ldbl \
    libmpfr-dev \
    libboost-dev \
    libboost-thread-dev \
    libtbb-dev \
    python3-dev \
    curl

# Install hera
WORKDIR /opt/
COPY build_hera.sh /opt/
RUN bash build_hera.sh && cp /opt/hera/build/bottleneck/bottleneck_dist /usr/local/bin/

# Install rivet
WORKDIR /opt
COPY build_rivet.sh /opt/
COPY rivet_fix_docopt.patch /opt/
RUN bash build_rivet.sh && cp /opt/rivet/build/rivet_console /usr/local/bin/

# Install pyrivet
WORKDIR /opt
COPY install_pyrivet.sh /opt/
RUN bash install_pyrivet.sh

# Install cgal
WORKDIR /opt
RUN git clone https://github.com/GUDHI/gudhi-deploy.git && bash gudhi-deploy/install_cgal.sh

# Install GUDHI
ARG GUDHI_VERSION="3.6.0"
RUN curl -LO "https://github.com/GUDHI/gudhi-devel/releases/download/tags%2Fgudhi-release-${GUDHI_VERSION}/gudhi.${GUDHI_VERSION}.tar.gz" \
    && tar xf gudhi.${GUDHI_VERSION}.tar.gz \
    && cd gudhi.${GUDHI_VERSION} \
    && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release -DWITH_GUDHI_PYTHON=OFF -DPython_ADDITIONAL_VERSIONS=3 ..  \
    && make all test install \
    && pip install gudhi

# Install shapely
RUN pip install shapely
# And rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y

ENV PATH="${HOME}/.cargo/bin:/root/.cargo/bin:${PATH}"
RUN pip install "filtration_domination==0.0.2"

# Install approximation of multipers
WORKDIR /opt
RUN git clone https://gitlab.inria.fr/dloiseau/multipers.git \
    && cd multipers \
    && git checkout 4785dcf56423cfcecca9799447c29b916e433f22 \
    && cd src \
    && pip install .

