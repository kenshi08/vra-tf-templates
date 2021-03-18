# Configure HyperV
provider "hyperv" {
  user            = "Administator"
  password        = var.win_password
  host            = "ec2-3-1-218-227.ap-southeast-1.compute.amazonaws.com"
  port            = 5985
  insecure        = true
  use_ntlm        = false
  script_path     = "C:/Temp/terraform_%RAND%.cmd"
  timeout         = "30s"
}

resource "hyperv_network_switch" "dmz_network_switch" {
  name = "dmz"
}

resource "hyperv_vhd" "web_server_g1_vhd" {
  path = "c:\\vhdx\\web_server_g1.vhdx" #Needs to be absolute path
  size = 10737418240 #10GB
}

resource "hyperv_machine_instance" "web_server_g1" {
  name = "web_server_g1"
  generation = 1
  processor_count = 2
  static_memory = true
  memory_startup_bytes = 536870912 #512MB
  wait_for_state_timeout = 10
  wait_for_ips_timeout = 10

  vm_processor {
    expose_virtualization_extensions = true
  }

  network_adaptors {
      name = "wan"
      switch_name = hyperv_network_switch.dmz_network_switch.name
      wait_for_ips = false
  }

  hard_disk_drives {
    controller_type = "Ide"
    path = hyperv_vhd.web_server_g1_vhd.path
    controller_number = 0
    controller_location = 0
  }

  dvd_drives {
    controller_number = 0
    controller_location = 1
    #path = "ubuntu.iso"
  }
}

resource "hyperv_vhd" "web_server_g2_vhd" {
  path = "c:\\vhdx\\web_server_g2.vhdx" #Needs to be absolute path
  size = 10737418240 #10GB
}

resource "hyperv_machine_instance" "web_server_g2" {
  name = "web_server_g2"
  generation = 2
  processor_count = 2
  static_memory = true
  memory_startup_bytes = 536870912 #512MB
  wait_for_state_timeout = 10
  wait_for_ips_timeout = 10

  vm_firmware {
    pause_after_boot_failure = "Off"
  }
  
  vm_processor {
    expose_virtualization_extensions = true
  }
  
  network_adaptors {
      name = "wan"
      switch_name = hyperv_network_switch.dmz_network_switch.name
      wait_for_ips = false
  }

  hard_disk_drives {
    path = hyperv_vhd.web_server_g2_vhd.path
    controller_number = 0
    controller_location = 0
  }

  dvd_drives {
    controller_number = 0
    controller_location = 1
    #path = "ubuntu.iso"
  }
}
