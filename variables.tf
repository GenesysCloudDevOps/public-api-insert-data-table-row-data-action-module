variable "action_name" {
    type        = string
    description = "Name of the data action." 
}

variable "action_category" {
    type        = string
    description = "Category of action."
}

variable "integration_id" {
    type        = string
    description = "Genesys Cloud integration id the data action will be associated with."
}

variable "secure_data_action" {
    type        = bool
    description = "True, Secure Data Action can only be invoked from a Secure flow. False, can be called from any flow."
    default     = false
}

variable "data_table_custom_fields" {
    type = set(object({
        field = string
        type  = string
    }))

    description = "List of objects defining custom data table fields. Example: [{\"field\": \"dob\", \"type\": \"string\"}]"

    validation {
        condition     = length(var.data_table_custom_fields) > 0 
        error_message = "The data_table_custom_fields set must contain at least 1 object."
    }
}
