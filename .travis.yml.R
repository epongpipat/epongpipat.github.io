language: R
sudo: required
cache: packages

script:
  - Rscript build_site.R

deploy:
  provider: pages                # Specify the gh-pages deployment method
skip_cleanup: true               # Don't remove files
github_token: $GITHUB_TOKEN      # Set in travis-ci.org dashboard
local_dir: docs                  # Deploy the docs folder
on:
  branch:
  - master
fqdn: ekarinpongpipat.com