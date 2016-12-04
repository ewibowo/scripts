#!/usr/local/bin/zsh

rm -rf .git
rm -rf .gitignore
mv .travis.yml docs
mv CONTRIBUTING.md docs
mv Dockerfile docker
mv LICENSE.txt docs
mv README.md docs
mv docker-compose.yml docker
mv mkdocs.yml docs
mv requirements.txt docs
mv upgrade.sh scripts
mv docker ~/Projects/NetEngineerONE/neteng/docker2
mv docs ~/Projects/NetEngineerONE/neteng/docs2
mv netbox ~/Projects/NetEngineerONE/neteng/netbox2
mv scripts ~/Projects/NetEngineerONE/neteng/scripts2
diff -r ~/Projects/NetEngineerONE/neteng/docker ~/Projects/NetEngineerONE/neteng/docker2 > docker.diff
diff -r ~/Projects/NetEngineerONE/neteng/netbox ~/Projects/NetEngineerONE/neteng/netbox2 > netbox.diff
diff -r ~/Projects/NetEngineerONE/neteng/scripts ~/Projects/NetEngineerONE/neteng/scripts2 > scripts.diff
