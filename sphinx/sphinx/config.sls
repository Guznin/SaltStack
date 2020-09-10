include:
  - {{ slspath }}.pkg

/etc/default/sphinxsearch:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - source: salt://{{ slspath }}/files/sphinx.conf

/var/run/sphinx:
  file.directory:
    - user: sphinx
    - group: sphinx
    - mode: '0755'
    - makedirs: true
    - require:
      - user: sphinx

/opt/sphinx:
  file.directory:
    - user: sphinx
    - group: sphinx
    - mode: '0755'
    - makedirs: true
    - require:
      - user: sphinx

/var/log/sphinxsearch:
  file.directory:
    - user: sphinx
    - group: sphinx
    - mode: '0755'
    - makedirs: true
    - require:
      - user: sphinx

/etc/security/limits.d/sphinx.conf:
  file.managed:
    - user: sphinx
    - group: sphinx
    - mode: '0644'
    - makedirs: true
    - source: salt://{{ slspath }}/files/sphinx_limit.conf
    - require:
      - user: sphinx

/etc/sphinx/sphinx.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - template: jinja
    - source: salt://{{ slspath }}/templates/sphinx.conf.jinja
    - require:
      - sls: {{ slspath }}.pkg

/etc/systemd/system/searchd.service:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - source: salt://{{ slspath }}/files/searchd.service

reload_systemctl_daemon:
  cmd.run:
    - name: "systemctl daemon-reload"
    - onchanges:
      - file: /etc/systemd/system/searchd.service

sphinx:
  user.present:
    - shell: /bin/bash
    - home: /home/sphinx
  group.present:
    - members:
        - sphinx