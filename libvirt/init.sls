{% if grains['os'] == 'CentOS' and grains['osmajorrelease'] >= 7 %}
include:
- .pkg
- .libvirt-network
{% endif %}
