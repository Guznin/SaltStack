{% from 'libvirt/maps/maps.jinja' import libvirt with context %}

libvirt_packages:
  pkg.installed:
  - names: {{ libvirt.pkgs | tojson }}
