# wget https://zenodo.org/record/3760403/files/ethainter.tar.bz2
# docker load -i ethainter.tar.bz2
FROM ethainter

# Precompile ethainter
RUN ./analyze.py --reuse_datalog_bin --restart -d ../.. -j 1 -C ../../ethainter-inlined.dl; rm -rf .temp results.json ../../contracts/*

USER root

RUN mkdir /data; chown reviewer.reviewer /data

COPY scripts/run.sh run.sh

ENTRYPOINT [ "bash", "run.sh" ]
