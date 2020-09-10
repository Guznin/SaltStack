{% from 'openvswitch/maps/maps.jinja' import openvswitch with context %}

Openvswitch repo:
    pkgrepo.managed:
        - name: openstack-stein
        - humanname: OpenStack Stein Repository
        - mirrorlist: http://mirrorlist.centos.org/?release=7&arch=$basearch&repo=cloud-openstack-stein
        - enabled: 1
        - gpgcheck: 0
        - order: 1
 
Openvswitch_package:
    pkg.installed:
        - pkgs:
        {%- for pkg_name in openvswitch.pkgs %}
            - {{ pkg_name }}
        {%- endfor %}
        - order: 2

{% for service_name in openvswitch.services %}
{{service_name}}_service:
    service.running:
        - name: {{ service_name }}
        - enable: True
{% endfor %}
