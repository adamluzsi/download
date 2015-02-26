# Download

Ruby Download helper that can handle even big file downloads too

## Use case

auth less use case

```ruby

  require 'download'
  Download.file(uri_path,target_local_file_path)

```

with basic auth

```ruby

  Download.file(
    'http://www.example.com/something.zip',
    http_basic_authentication: ['username', '123abc']
  )

```

## Behavior

if the target file path is a directory, the file name will be based on the uri-s file name.
if no file path given, than the default location will be the current directory with the file uri name

The #file default return is a file path