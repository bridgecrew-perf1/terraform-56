## DynamoDB items

This module manages a list of items in a DynamoDB table.
It is not meant to be used for managing large amounts of data.

### Usage:

Define a variable and populate it with items as follows:

```json
variable "dynamodb_items" {
  description = "List of maps of attribute name/value pairs, one for each attribute"
  type        = "list"

  default = [
    {
      "prefix" = {
        "S" = "CAR_aegis/both"
      }

      "destination" = {
        "S" = <<ITEM
      {
      "disposition": "customer360-decrypt-gpg-files/CAR_aegis/both/disposition-decrypted/", 
      "sales" : "customer360-decrypt-gpg-files/CAR_aegis/both/sales-decrypted/"
      }
      ITEM
      }

      "key" = {
        "S" = "ttgsl-dev-sm-dpds-key1"
      }
    },
    {
      "prefix" = {
        "S" = "CAR_ancillary"
      }

      "destination" = {
        "S" = "customer360-decrypt-gpg-files/CAR_ancillary/decrypt"
      }

      "key" = {
        "S" = "ttgsl-dev-sm-dpds-key1"
      }
    }
  ]
}
```

It's possible to use "heredoc" the syntax in the value field. The _destination_ key above is an example.

Then call the module as follows:

```json
module "dynamodb-items" {
  source = "../../../../../../../../data-terraform/modules/aws/dynamodb/items"

  table_name = "${var.dynamodb_tablename}"
  hash_key   = "${var.hash_key}"
  items      = "${var.dynamodb_items}"
}
```

This assumes the DynamoDB table has already been created. If the table creation occurs in the same stack, make sure this module is always called after the table creation.