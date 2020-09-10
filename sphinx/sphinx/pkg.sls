{% from 'sphinx/maps/map.jinja' import sphinx with context %}

Sphinx_dependences:
  pkg.installed:
    - names: {{ sphinx.pkgs | tojson }}

Sphinx_package:
  pkg.installed:
    - sources:
      - sphinx: {{ sphinx.rpm_file }}
