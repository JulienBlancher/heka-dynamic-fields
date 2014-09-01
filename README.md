Parses a monolog json line, and add each key as a field with its value for elasticsearch.

Config:
    none

*Example Heka Configuration*

.. code-block:: ini

    [DynamicDecoder]
    type = "SandboxDecoder"
    filename = "/var/www/heka/sandbox/lua/decoders/dynamic_fields.lua"

*Example Heka Message*
```
:Uuid: 5241d061-d807-413f-aebe-0cb3e40639f1
:Timestamp: 2014-09-01T15:08:11.000Z
:Type: logfile
:Logger: BusinessLog
:Severity: 7
:Payload: 
:EnvVersion: 
:Pid: 0
:Hostname: lmde-dev
:type: Evaluation
:Fields:
    | :eval: 5
    | :parent: Nico
    | :sitter: Julien
    | :timezone: Europe/Paris
    | :Message: coucou
    | :timezone_type: 3
    | :channel: businesslog
    | :extratest: a little extra
    | :Level: 200
    | :Level_Name: INFO
    | :date: 2014-09-01 17:08:11
```
