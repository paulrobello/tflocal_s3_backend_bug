### S3 backend causes issue with terraform always thinking backend configuration has changed

### To deploy
``` bash
pip install -r requirements.txt
make deploy
```

you will get an error like this:
``` bash
Error: Backend initialization required: please run "terraform init"

Reason: Backend configuration block has changed
```
### BUG fixed as of ver 0.18.1
