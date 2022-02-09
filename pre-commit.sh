#!/bin/bash

PRECOMMIT_SCRIPT_PATH=".git/hooks/pre-commit"

cat > $PRECOMMIT_SCRIPT_PATH <<EOF
#!/bin/bash
if pre-commit run -a; then
 echo "pre-commit tests passed!"
else
 echo "pre-commit tests failed!"
 git add .
fi

EOF

chmod +x $PRECOMMIT_SCRIPT_PATH