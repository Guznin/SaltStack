{% from 'openvswitch/maps/maps.jinja' import openvswitch with context %}

{%- for iface in openvswitch.network.get('ifaces', []) %}
/etc/sysconfig/network-scripts/ifcfg-{{ iface['name'] }}:
    file.managed:
        - contents: |
            # Managed by Salt!
        {%- for k, v in iface|dictsort %}
            {{k|upper}}="{{v}}"
        {%- endfor %}
{%- endfor %}
