#Reference https://www.terraform.io/docs/providers/azurerm/r/route_table.html

resource "azurerm_route_table" "route_table" {
  name                          = var.route_table.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tags                          = local.tags
  disable_bgp_route_propagation = lookup(var.route_table, "disable_bgp_route_propagation", null)

  dynamic "route" {
    for_each = var.route_table.route_entries
    content {
      name                   = route.value.name
      address_prefix         = route.value.prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_type == "VirtualAppliance" ? (var.next_hop_in_dynamic_private_ip != null && var.next_hop_in_dynamic_private_ip != "null" && var.next_hop_in_dynamic_private_ip != "" ? var.next_hop_in_dynamic_private_ip : route.value.next_hop_in_ip_address) : null
    }
  }
}