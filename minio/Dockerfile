FROM minio/mc:RELEASE.2023-11-20T16-30-59Z as mc
FROM minio/minio:RELEASE.2023-11-20T22-40-07Z

COPY --from=mc /usr/bin/mc /usr/bin/mc

COPY startup.sh /usr/bin/startup.sh

ENTRYPOINT ["/usr/bin/startup.sh"]

# TODO Add access keys automatically
