FROM gitea/gitea:1.21.10

COPY startup.sh /setup/
ENTRYPOINT ["/setup/startup.sh"]

# TODO Add OAuth App for Woodpecker Server by default
# Not currently possible according to
# https://github.com/go-gitea/gitea/issues/8764

# TODO Add the embci-example-repo by default
