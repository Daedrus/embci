FROM minio/mc:RELEASE.2024-06-12T14-34-03Z as mc
FROM minio/minio:RELEASE.2024-06-13T22-53-53Z

COPY --from=mc /usr/bin/mc /usr/bin/mc

COPY startup.sh /usr/bin/startup.sh

ENTRYPOINT ["/usr/bin/startup.sh"]

# TODO Add access keys automatically
