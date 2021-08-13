Sample Python code used to decrypt password vault entries:

```python
from cryptography.fernet import Fernet
import base64
from hashlib import md5

pin = "0000"

# EncryptionInfo: Fernet, salt is md5({PIN})
pinMd5 = md5(pin.encode()).hexdigest().encode()
dataEncrypted = b"gAAAAABeyYn1oVWbzoTkSgUNBi2F/NdXhh/gU6+nqCw5cDgcpQtNaTu8AdWGx8CUp0jvcYILTA7638uOZO977yGx385Uv29Cheeg8qxnQAdsbYD6RcQyyOE="

key = base64.b64encode(pinMd5)
fernet = Fernet(key)
decrypted = fernet.decrypt(dataEncrypted)

print(decrypted)
```