# GHRH

Manage GitHub repository [hooks](http://developer.github.com/v3/repos/hooks/) easily on the command line.

## Installation

Install the ruby gem:

``` sh
$ gem install ghrh
```

## Usage

### General help
``` sh
$ ghrh --help
Usage:
    ghrh [OPTIONS] SUBCOMMAND [ARG] ...

Parameters:
    SUBCOMMAND                    subcommand
    [ARG] ...                     subcommand arguments

Subcommands:
    auth                          get auth token from github
    create                        create hook
    delete                        delete hook
    edit                          edit hook
    get                           get information for a hook
    hooks                         list known hooks and their parameters
    list                          list hooks
    test                          test hook

Options:
    -h, --help                    print help
```
Pass `--help` to each sub command for its usage.

### Setting up
The Github token (`ghrh.token`), repository (`github.repo`), user (`github.user`) and host (`github.host`) are set and picked up from
the local or global git config. Environment variables work too `GITHUB_REPO`, `GITHUB_USER`, etc.

``` sh
# fetch and set GitHub token, also can be set repository specific (pass --local)
$ ghrh auth r4um
Enter password for user r4um (never stored):
ghrh.token set to xyz012345 in global git config
```

### Managing hooks

ghrh caches the hooks metadata from GitHub host in `~/.ghrh`.

List available hooks
``` sh
$ ghrh hooks
activecollab
acunote
agilebench
agilezen
amazonsns
apiary
apoio
appharbor
asana
backlog
---cut---
```

View what paramaters (the schema) hook expects
``` sh
$ ghrh hooks email
{"name"=>"email",
 "events"=>["push"],
 "supported_events"=>["public", "push"],
 "schema"=>
  [["string", "address"],
   ["password", "secret"],
   ["boolean", "send_from_author"]]}
```

The parameters are passed as `key=value` pairs, for example create an email and a web hook
``` sh
$ ghrh create -r r4um/dotfiles email address=pranay.kanwar@gmail.com send_from_author=1
201 Created
$ ghrh create -r r4um/dotfiles web url=http://foo.com content_type=text/json
201 Created
```
Events can be selected via `-e` switch.

If no repository is provided its picked up from `github.repo` git config setting.

Too see a list of hooks

``` sh
$ ghrh list r4um/dotfiles
-------------------------------
 id      name   active  events
-------------------------------
 954777  email  true    push
 956443  web    true    push
-------------------------------
```

Hooks can be viewed, edited, tested or deleted by their id from the list above.

``` sh
$ ghrh edit -r r4um/dotfiles 954777 address=nobody@localhost
200 OK
$ ghrh get -r r4um/dotfiles 954777
200 OK
{"url"=>"https://api.github.com/repos/r4um/dotfiles/hooks/954777",
 "test_url"=>"https://api.github.com/repos/r4um/dotfiles/hooks/954777/test",
 "id"=>954777,
 "name"=>"email",
 "active"=>true,
 "events"=>["push"],
 "config"=>{"address"=>"nobody@localhost"},
 "last_response"=>{"code"=>200, "status"=>"ok", "message"=>"OK"},
 "updated_at"=>"2013-05-14T12:19:30Z",
 "created_at"=>"2013-05-13T19:52:50Z"}
$ ghrh test -r r4um/dotfiles 954777
204 No Content
nil
$ ghrh delete -r r4um/dotfiles 954777
204 No Content

Deleted
```

To refresh the hooks cache
``` sh
$ ghrh hooks --refresh
Wrote hooks cache to /Users/pranay.kanwar/.ghrh/hooks_api.github.com.json
```

### LICENSE
[MIT](LICENSE)
