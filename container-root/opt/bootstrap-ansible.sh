#!/bin/bash

register-python-argcomplete ansible-config | tee /etc/bash_completion.d/python-ansible-config >/dev/null
register-python-argcomplete ansible-console | tee /etc/bash_completion.d/python-ansible-console >/dev/null
register-python-argcomplete ansible-doc | tee /etc/bash_completion.d/python-ansible-doc >/dev/null
register-python-argcomplete ansible-galaxy | tee /etc/bash_completion.d/python-ansible-galaxy >/dev/null
register-python-argcomplete ansible-inventory | tee /etc/bash_completion.d/python-ansible-inventory >/dev/null
register-python-argcomplete ansible-playbook | tee /etc/bash_completion.d/python-ansible-playbook >/dev/null
register-python-argcomplete ansible-pull | tee /etc/bash_completion.d/python-ansible-pull >/dev/null
register-python-argcomplete ansible-vault | tee /etc/bash_completion.d/python-ansible-vault >/dev/null

chmod a+rx /etc/bash_completion.d/python-a*