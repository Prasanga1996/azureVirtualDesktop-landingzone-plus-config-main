variable "tagWorkload" {
  type = string
  default = "Virtual Desktop"
   validation {
    condition     = contains(["Virtual Desktop","Web Apps","Domain Services"],var.tagWorkload)
    error_message = "Valid value is one of the following:Virtual Desktop,Web Apps,Domain Services"
  }
}

variable "tagManagedBy" {
  type = string
  default = "Alliance Business Technologies"
  description = "Options for Tags"
}

variable "tagEnvironment" {
  type = string
  default = "Production"
  validation {
    condition     = contains(["Production","Development","Testing","Recovery"],var.tagEnvironment)
    error_message = "Valid value is one of the following:Production,Development,Testing,Recovery"
  }
}

variable "tagImpact" {
  type = string
  default = "High Impact"
  validation {
    condition     = contains(["Business-Critical","High Impact","Low Impact","Zero Impact"],var.tagImpact)
    error_message = "Valid value is one of the following:Business-Critical,High Impact,Low Impact,Zero Impact"
  }
}

variable "clientShortHand" {
  description = "Used for globally unique storage account names"
  type = string
  default = "ABT"
  validation {
condition = length(var.clientShortHand) >= 2 && length(var.clientShortHand) <= 5
error_message = "clientShortHand must be between 2 and 5 characters long"
  }
}

#Check this
variable "subscriptionLocation" {
  type = string
   description = "Location for this resource matches the location from the resource group"
  default = "australiaeast"
}
