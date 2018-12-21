output "id" {
  value = "${cloudflare_page_rule.main.id}"
}

output "zone_id" {
  value = "${cloudflare_page_rule.main.zone_id}"
}

output "target" {
  value = "${cloudflare_page_rule.main.target}"
}

output "actions" {
  value = "${cloudflare_page_rule.main.actions}"
}

output "priority" {
  value = "${cloudflare_page_rule.main.priority}"
}

output "status" {
  value = "${cloudflare_page_rule.main.status}"
}
