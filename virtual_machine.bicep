param name string
param location string
param vmSize string = 'Standard_D4s_v3'
param subnetId string
param offer string = '0001-com-ubuntu-server-focal'
param publisher string = 'canonical'
param sku string = '20_04-lts'
param version string = 'latest'
param adminUsername string = 'adminuser'
param ssh_public_key string = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwTXfsS4+FRigKOYxWt9NYIQ2nSEA+dRu40d2+gkYEaZEuXpTL1VO+PNHzibC9v6zKwBD2bTyvCGb88/ybB6uKicUKlZhNKZs+tSvyrhgF+15Xh/3K1gS+ZAGszt3xUBHPynM4HcOU/anx32zO+lHCRUDPkbSeRlXzUsUJ0tC0aoye9kQsh96jF9Z2OrTPL42eLmLtK+uVNHwQvrhmuYrRAdlTM1we6Brf0AqeX8t1qNTMF9oURNSAFL5S21V+gYQlXIflUSEoFpHEWy/I9Drt6OREW6alxbuTHTw8LFk0E4yIWuOUXgYsnJt84W0EElyip7LJyzEtdg06NSeVhxSB'
param storageAccountType string = 'StandardSSD_LRS'


resource vmnic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'vmnic'
  location: location
  properties:{
    ipConfigurations:[
      {
        name: 'ipconfig1'
        properties:{
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          privateIPAddressVersion:'IPv6'
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: name
  location: location
  properties: {
    hardwareProfile:{
      vmSize: vmSize
    }
    osProfile:{
      adminUsername: adminUsername
      linuxConfiguration:{
        ssh:{
          publicKeys : [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: ssh_public_key
            }
          ]
        }
        disablePasswordAuthentication:true
      }
      computerName: 'samplelinux'
    }
    networkProfile:{
      networkInterfaces:[
        {
          id: vmnic.id
        }
      ]
    }
    storageProfile:{
      imageReference:{
        offer: offer
        publisher: publisher
        version: version
        sku: sku
      }
      osDisk:{
        createOption:'FromImage'
        managedDisk:{
          storageAccountType: storageAccountType
        }
      }
    }
    diagnosticsProfile:{
      bootDiagnostics:{
        enabled: true
      }
    }
  }
}
