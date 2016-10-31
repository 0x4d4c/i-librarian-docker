# i-librarian-docker

**NB:** This image is meant to be run either behind a reverse proxy or on your local system only. Do **NOT** expose the port directly to the Internet!

# Configuration
All configuration is done via environment variables. The [generate-config.sh](scripts/generate-config.sh) script which is called from the [entrypoint](scripts/entrypoint.sh) reads the environment variables and generate the required config files for you.


## Available Configuration Parameters

| Parameter | Default | Description |
| --------- | ------- | ----------- |
| `ILIBRARIAN_RELATIVE_URL_ROOT` | `"/librarian"` | Relative URL of I, Librarian service. |
| `ILIBRARIAN_TEMP_PATH` | `""` | Custom temporary storage folder path. |
| `ILIBRARIAN_STABLELINKS` | `"0"` | Enable (1) or disable (0) unrestricted access to stable item links. |
| `ILIBRARIAN_RSSLINKS` | `"0"` | Enable (1) or disable (0) unrestricted access to RSS links. |
| `ILIBRARIAN_AUTOSIGN` | `"0"` | Enable automatic sign in. |
| `ILIBRARIAN_USERNAME` | `""` | Auto sign in user. |
| `ILIBRARIAN_RESET_PASSWORD` | `"0"` | Enable (1) or disable (0) password reset. |
| `ILIBRARIAN_GREETING` | `"I, Librarian"` | Custom greeting on the sign in page. |
| `ILIBRARIAN_MAIN_WINDOW_FONT_FAMILY` | `"Liberation Sans"` | Main window font family. |
| `ILIBRARIAN_MAIN_WINDOW_FONT_SIZE` | `"14"` | Main window font size. |
| `ILIBRARIAN_MAIN_WINDOW_COLOR` | `"222222"` | Main window color. |
| `ILIBRARIAN_MAIN_WINDOW_LINE_HEIGHT` | `"1.4"` | Main window line height. |
| `ILIBRARIAN_MAIN_WINDOW_LINK_COLOR` | `"404FC3"` | Color of links. |
| `ILIBRARIAN_MAIN_WINDOW_HIGHLIGHT_COLOR` | `"FF4500"` | Color of highlights. |
| `ILIBRARIAN_MAIN_WINDOW_TITLE_FONT_FAMILY` | `"Liberation Sans"` | Title font family. |
| `ILIBRARIAN_MAIN_WINDOW_TITLE_FONT_SIZE` | `"14"` | Title font size. |
| `ILIBRARIAN_MAIN_WINDOW_ABSTRACT_FONT_FAMILY` | `"Liberation Sans"` | Abstract font family. |
| `ILIBRARIAN_MAIN_WINDOW_ABSTRACT_FONT_SIZE` | `"14"` | Abstract font size. |
| `ILIBRARIAN_MAIN_WINDOW_ABSTRACT_LINE_HEIGHT` | `"1.5"` | Abstract line height. |
| `ILIBRARIAN_MAIN_WINDOW_FORM_FONT_FAMILY` | `"Liberation Sans"` | Form font family. |
| `ILIBRARIAN_MAIN_WINDOW_FORM_FONT_SIZE` | `"14"` | Form font size. |
| `ILIBRARIAN_MAIN_WINDOW_BACKGROUND_COLOR` | `"FFFFFF"` | Main window background color. |
| `ILIBRARIAN_ALTERNATING_ROW_BACKGROUND_COLOR` | `"F3F3F3"` | Alternating row background color. |
| `ILIBRARIAN_TOP_WINDOW_BACKGROUND_COLOR` | `"404FC3"` | Top window background color. |
| `ILIBRARIAN_TOP_WINDOW_COLOR` | `"FFFFFF"` | Top window color. |
| `ILIBRARIAN_LDAP_ACTIVE` | `false` | Activate/deactivate login via LDAP. Activating LDAP disables local login and you have to enable the LDAP module in `php.ini`. |
| `ILIBRARIAN_LDAP_DEBUG_ENABLED` | `false` | Enable/disable LDAP debug information for LDAP authentication. |
| `ILIBRARIAN_LDAP_OPT_DEBUG_LEVEL` | `7` | Debug log level for LDAP authentication. |
| `ILIBRARIAN_LDAP_VERSION` | `3` | LDAP protocol version. |
| `ILIBRARIAN_LDAP_OPT_REFERRALS` | `0` | Enable/disable REFERRALS. |
| `ILIBRARIAN_LDAP_SERVER` | `"ldap://ldap.forumsys.com:389"` | LDAP server URL. |
| `ILIBRARIAN_LDAP_BASEDN` | `"dc=example,dc=com"` | Base distinguished name (DN). |
| `ILIBRARIAN_LDAP_BINDUSER_DN` | `""` | Fully qualified DN of the bind user. |
| `ILIBRARIAN_LDAP_BINDUSER_PW` | `"password"` | Password of the bind user. |
| `ILIBRARIAN_LDAP_USERNAME_ATTR` | `"uid"` | Attribute to use for username lookups. |
| `ILIBRARIAN_LDAP_USERLOGIN_ATTR` | `"uid"` |  |
| `ILIBRARIAN_LDAP_USER_RDN` | `""` | User relative search base (without base DN). |
| `ILIBRARIAN_LDAP_USERGROUP_RDN` | `"ou=groups"` | Group relative search base (without base DN) - could be emtpy. |
| `ILIBRARIAN_LDAP_USERGROUP_CN` | `""` | User group common name. |
| `ILIBRARIAN_LDAP_ADMINGROUP_CN` | `"cn=read-only-admin"` | Admin group common name. |
| `ILIBRARIAN_LDAP_FILTER` | `"member"` | Authorization filter prefix. |

## Reverse Proxy
As already mentioned, you should use a reverse proxy if you want to make your *I, Librarian* container accessible from the Internet. Here's an example using [nginx](https://nginx.org/):

```
server {
  listen  443 ssl;
  server_name your.domain;
  root /some/www/root/;
  
  ssl_certificate           /path/to/ssl.cert;
  ssl_certificate_key       /path/to/ssl.key;
  ssl_protocols             TLSv1 TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on;
  ssl_ciphers               'AES256+EECDH:AES256+EDH:!aNULL';
  [... other TLS related settings ...]

  # I, Librarian reverse proxy
  location /librarian {  #  or whatever you set ILIBRARIAN_RELATIVE_URL_ROOT to
    proxy_pass       http://127.0.0.1:8000/librarian;  # see above
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    add_header       Front-End-Https on;
  }
}
```
Then start the container with:
```
$ docker run -d --name i-librarian -p 127.0.0.1:8000:80 0x4d4c/i-librarian
```

# Persistence
*I, Librarian* stores its data (i. e. your user data, the user and settings database etc.) under `library_path`/library. This image has `library_path` set to `/data` which is defined to be a volume. So you can either let Docker manage this volume or you can mount a host directory to your container like this:
```bash
$ docker run -d --name i-librarian --volume /some/host/dir:/data 0x4d4c/i-librarian
```

