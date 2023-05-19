locals {
    contract_input_custom_fields      = "%{ for obj in var.data_table_custom_fields } \"${obj.field}\": { \"type\": \"${obj.type}\" }, %{ endfor }"
    contract_output_custom_properties = "%{ for obj in var.data_table_custom_fields } \"${obj.field}\": { \"type\": \"${obj.type}\", \"title\": \"${obj.field}\" }, %{ endfor }"
}

resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = format("{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"description\":\"Create data table row\",\"properties\":{ %s \"DatatableId\":{\"description\":\"Data Table ID\",\"type\":\"string\"},\"Key\":{\"description\":\"Data Table Row Identifier\",\"type\":\"string\"}},\"required\":[\"Key\"],\"title\":\"Create data table row\",\"type\":\"object\"}", local.contract_input_custom_fields)
    contract_output = format("{\"$schema\":\"http://json-schema.org/draft-04/schema#\",\"description\":\"returns the new row\",\"properties\":{ %s \"key\":{\"title\":\"key\",\"type\":\"string\"}},\"title\":\"Row update\",\"type\":\"object\"}", local.contract_output_custom_properties)
    
    config_request {
        request_template     = "{\n    \"key\":\"$${input.Key}\"\n %{ for obj in var.data_table_custom_fields } ,\"${obj.field}\": %{ if obj.type == "string" }\"%{ endif }$!{input.${obj.field}}%{ if obj.type == "string" }\"%{ endif }\n %{ endfor } \n}"
        request_type         = "POST"
        request_url_template = "/api/v2/flows/datatables/$${input.DatatableId}/rows"
    }

    config_response {
        success_template = "$${rawResult}"
    }
}