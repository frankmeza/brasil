These sequence diagrams are easily viewed (and edited) on [StackEdit](https://stackedit.io/), using [MermaidJS](https://mermaidjs.github.io/).


## Auth Controller

### LOGIN

```mermaid
sequenceDiagram
participant B as browser
participant A as app.rb
participant Au as AuthCtrl

B ->> A: POST "/auth/login", {"login", "password"}
A ->> Au: run AuthCtrl with request
Note over Au: parse request body of {"login", "password"}
Au ->> Au: 
Note over Au: using Shield, match login and password to existing user
Au ->> Au: 
Note over Au: if true then fetch User, encode data using secret key and HS256
Au ->> B: set HTTP status 201 and issue token

Note over Au: if false, halt request
Au ->> B: set HTTP status 401, and write response { error: invalid_credentials }
```

### LOGOUT

```mermaid
sequenceDiagram
participant B as browser
participant A as app.rb
participant Au as AuthCtrl

B ->> A: GET "/auth/logout"
A ->> Au: run AuthCtrl with request
Note over Au: using Shield, logout user 
Au ->> B: set HTTP status 200, write response {"logged_out": true} 
```

## USER CONTROLLER

### GET "/"

```mermaid
sequenceDiagram
participant B as browser
participant A as app.rb
participant U as UserCtrl
participant user as User

B ->> A: GET "/users"
A ->> U: run UserCtrl with request
U ->> user: call User.all
user ->> U: yield all Users
Note over U: map Users, and serialize Users -> { :id, :username, :email, :is_admin }
U ->> B: write response { "users": users }
```

### GET "/users/username/:username"

```mermaid
sequenceDiagram
participant B as browser
participant A as app.rb
participant U as UserCtrl
participant user as User

B ->> A: GET "/users/username/:username"
A ->> U: run UserCtrl with request
U ->> user: call User.fetch_by_username(username)
user ->> U: yield correct User
Note Over U: serialize User -> { :id, :username, :email, :is_admin }
U ->> B: write response { "user": user }
```
