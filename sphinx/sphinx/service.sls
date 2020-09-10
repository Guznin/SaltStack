include:
  - {{ slspath }}.config

searchd:
  service.running:
  - enable: True
  - watch:
    - file: /etc/sphinx/sphinx.conf
  - require:
    - sls: {{ slspath }}.config
