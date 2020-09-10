{% from 'libvirt/maps/maps.jinja' import libvirt with context %}

include:
  - {{ slspath }}.pkg

{% for service_name in libvirt.services %}
{{ service_name }}:
  service.running:
    - enable: True
    - require:
      - sls: {{ slspath }}.pkg
 {% endfor %}

# Copy network config file 
{{ libvirt.tmp_dir }}/{{ libvirt.network_name }}.xml:
  file.managed:
      - source: salt://libvirt/templates/{{ libvirt.network_name }}.xml.jinja
      - template: jinja
      - require:
        - sls: {{ slspath }}.pkg

# Create ovs network
create_libvirt_network:
  cmd.run:
    - name: virsh net-define {{ libvirt.tmp_dir }}/{{ libvirt.network_name }}.xml && virsh net-start {{ libvirt.network_name }}
    - unless: virsh net-list --name | grep '^{{ libvirt.network_name }}$'
    - require:
      - file: {{ libvirt.tmp_dir }}/{{ libvirt.network_name }}.xml

set_autostart_libvirt_network:
  cmd.run:
    - name: virsh net-autostart {{ libvirt.network_name }}
    - unless: virsh net-list --autostart --name | grep '^{{ libvirt.network_name }}$'
    - require:
      - cmd: create_libvirt_network

remove_default_network:
  cmd.run:
    - name: virsh net-destroy default && virsh net-undefine default
    - onlyif: virsh net-list --name | grep '^default$'
    - require:
      - sls: {{ slspath }}.pkg
