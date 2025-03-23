FROM minio/mc:RELEASE.2025-03-12T17-29-24Z as mc
FROM minio/minio:RELEASE.2025-03-12T18-04-18Z

COPY --from=mc /usr/bin/mc /usr/bin/mc

COPY startup.sh /usr/bin/startup.sh

ENTRYPOINT ["/usr/bin/startup.sh"]

# TODO Add access keys automatically
