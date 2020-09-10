/usr/bin/indexer --config /etc/sphinx/sphinx.conf user_core_{{ salt['pillar.get']('sphinx:index_parameters:partition') }}_delta --rotate:
  cron.present:
    - minute: '*/10'
    - user: sphinx
    - identifier: 'sphinx delta index'

/usr/bin/indexer --config /etc/sphinx/sphinx.conf user_core_{{ salt['pillar.get']('sphinx:index_parameters:partition') }} --rotate --sighup-each:
  cron.present:
    - special: '@daily'
    - user: sphinx
    - identifier: 'sphinx full index'
  cmd.run:
    - runas: sphinx
    - creates:
    {% for extension in ['spa','spd','spe','sph','spi','spk','spl','spm','spp','sps'] %}
      - /opt/sphinx/user_core_{{ salt['pillar.get']('sphinx:index_parameters:partition') }}.{{ extension }}
    {% endfor %}
