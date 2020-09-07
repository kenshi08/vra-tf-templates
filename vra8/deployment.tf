resource "vra_deployment" "this" {
  name        = var.deployment_name
  description = "Deployed from vRA provider for Terraform."

  blueprint_id      = vra_blueprint.this.id
  project_id        = vra_project.this.id

  inputs = {
    flavor = "small"
    image  = "ubuntu1604"
  }
  depends_on = [
    vra_project.this, 
    vra_network_profile.simple,
    vra_blueprint.this,
    vra_zone.zone_aws_west,
    time_sleep.wait_180_seconds
  ]
}