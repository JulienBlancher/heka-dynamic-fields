--[[
Copyright Julien Blancher. You can use this code for all purposes.

Parses a monolog json line, and add each key as a field with its value for elasticsearch.

Config:
    none

*Example Heka Configuration*

.. code-block:: ini

    [DynamicDecoder]
    type = "SandboxDecoder"
    filename = "/var/www/heka/sandbox/lua/decoders/dynamic_fields.lua"

*Example Heka Message*

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

--]]

-- Include json utilities
json = require("cjson")

-- Define data structure to send to elasticsearch
local msg = {
    Timestamp   = nil,
    Type        = msg_type,
    Hostname    = nil,
    Payload     = nil,
    Pid         = nil,
    Severity    = nil,
    Fields      = nil
}

function process_message ()

    local fields = {}

    -- Get the log line
    local log = read_message("Payload")

    -- Unserialize the json
    local log_array = cjson.decode(log)

    -- Add the basic fields
    fields.Message = log_array["message"]
    fields.Level = log_array["level"]
    fields.Level_Name = log_array["level_name"]
    fields.channel = log_array["channel"]

    -- Add context fields
    for key,value in pairs(log_array["context"])
    do
            fields[key] = value
    end

    -- Add datetime fields
    for key,value in pairs(log_array["datetime"])
    do
            fields[key] = value
    end

    -- Add extra fields
    for key,value in pairs(log_array["extra"])
    do
            fields[key] = value
    end

    msg.Fields = fields
    inject_message(msg)
    return 0
end
