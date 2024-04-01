FROM minio/mc:RELEASE.2024-03-30T15-29-52Z as mc
FROM minio/minio:RELEASE.2024-03-30T09-41-56Z

COPY --from=mc /usr/bin/mc /usr/bin/mc

COPY startup.sh /usr/bin/startup.sh

ENTRYPOINT ["/usr/bin/startup.sh"]

# TODO Add access keys automatically
