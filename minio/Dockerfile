FROM minio/mc:RELEASE.2024-01-13T08-44-48Z as mc
FROM minio/minio:RELEASE.2024-01-13T07-53-03Z

COPY --from=mc /usr/bin/mc /usr/bin/mc

COPY startup.sh /usr/bin/startup.sh

ENTRYPOINT ["/usr/bin/startup.sh"]

# TODO Add access keys automatically
