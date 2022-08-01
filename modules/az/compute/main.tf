resource "azurerm_subnet_network_security_group_association" "rg" {
  subnet_id                 = azurerm_subnet.rg.id
  network_security_group_id = azurerm_network_security_group.rg.id
}

resource "azurerm_network_interface" "rg" {
  name                = "example-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.rg.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "rg" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  network_interface_ids = [
    azurerm_network_interface.rg.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  computer_name  = "ubuntu-linux-vm"
  admin_username = "adminuser"
  admin_password = "Somepass123!"
  disable_password_authentication = false

  source_image_reference {
    publisher = "Oracle-Linux"
    offer     = "oracle-database-19-3"
    sku       = "oracle-db-19300"
    version   = "latest"
  }
