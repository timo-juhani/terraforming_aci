provider "aci" {
  username = var.username
  password = var.password
  insecure = true
  url      = var.url
}

resource "aci_tenant" "mars" {
  name        = var.tenant
  description = "created by Terraform!"
}

resource "aci_vrf" "mars_vrf" {
  tenant_dn = aci_tenant.mars.id
  name      = "mars_vrf"
}

resource "aci_bridge_domain" "mars_100" {
  tenant_dn          = aci_tenant.mars.id
  relation_fv_rs_ctx = aci_vrf.mars_vrf.id
  name               = "mars_100"
}

resource "aci_subnet" "mars_100_subnet" {
  bridge_domain_dn = aci_bridge_domain.mars_100.id
  ip               = var.bd_subnet
}

resource "aci_filter" "allow_https" {
  tenant_dn = aci_tenant.mars.id
  name      = "allow_https"
}
resource "aci_filter" "allow_ssh" {
  tenant_dn = aci_tenant.mars.id
  name      = "allow_ssh"
}

resource "aci_filter_entry" "https" {
  name        = "https"
  filter_dn   = aci_filter.allow_https.id
  ether_t     = "ipv4"
  prot        = "tcp"
  d_from_port = "443"
  d_to_port   = "443"
  stateful    = "yes"
}

resource "aci_filter_entry" "ssh" {
  name        = "ssh"
  filter_dn   = aci_filter.allow_ssh.id
  ether_t     = "ipv4"
  prot        = "tcp"
  d_from_port = "22"
  d_to_port   = "22"
  stateful    = "yes"
}

resource "aci_contract" "baseline" {
  tenant_dn = aci_tenant.mars.id
  name      = "baseline"
}

resource "aci_contract_subject" "baseline_subj" {
  contract_dn                  = aci_contract.baseline.id
  name                         = "baseline_subj"
  relation_vz_rs_subj_filt_att = [aci_filter.allow_https.id, aci_filter.allow_ssh.id]
}

resource "aci_application_profile" "mars_app" {
  tenant_dn = aci_tenant.mars.id
  name      = "mars_app"
}

resource "aci_application_epg" "mars_101" {
  application_profile_dn = aci_application_profile.mars_app.id
  name                   = "mars_101"
  relation_fv_rs_bd      = aci_bridge_domain.mars_100.id
  relation_fv_rs_cons    = [aci_contract.baseline.id]
}

resource "aci_application_epg" "mars_102" {
  application_profile_dn = aci_application_profile.mars_app.id
  name                   = "mars_102"
  relation_fv_rs_bd      = aci_bridge_domain.mars_100.id
  relation_fv_rs_prov    = [aci_contract.baseline.id]
}
