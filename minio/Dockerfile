FROM minio/mc:RELEASE.2024-03-07T00-31-49Z as mc
FROM minio/minio:RELEASE.2024-03-07T00-43-48Z

COPY --from=mc /usr/bin/mc /usr/bin/mc

COPY startup.sh /usr/bin/startup.sh

ENTRYPOINT ["/usr/bin/startup.sh"]

# TODO Add access keys automatically
