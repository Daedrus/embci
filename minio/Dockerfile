FROM minio/mc:RELEASE.2024-04-29T09-56-05Z as mc
FROM minio/minio:RELEASE.2024-06-04T19-20-08Z

COPY --from=mc /usr/bin/mc /usr/bin/mc

COPY startup.sh /usr/bin/startup.sh

ENTRYPOINT ["/usr/bin/startup.sh"]

# TODO Add access keys automatically
