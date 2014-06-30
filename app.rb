# IPv4 Fixed Mask Network Calculator
# Copyright (C) 2014 Luis Enrique Arriojas
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU Affero General Public License as
#published by the Free Software Foundation, either version 3 of the
#License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#GNU Affero General Public License for more details.
#
#You should have received a copy of the GNU Affero General Public License
#along with this program. If not, see <http://www.gnu.org/licenses/>.

system "clear"

puts "********************************************"
puts "* IPv4 Fixed Mask Network Calculator       *"
puts "* Copyright (C) 2014 Luis Enrique Arriojas *"
puts "* http://github.com/luisarriojas           *"
puts "* Licensed under AGPLv3                    *"
puts "********************************************"
puts

#Function to build mask in IP format
def getMaskIp(bits)
  if bits <= 8
    maskIp = (256 - (2 ** (8 - bits))).to_s + ".0.0.0"
  elsif (bits >= 9) && (bits <= 16)
    maskIp = "255." + (256 - (2 ** (16 - bits))).to_s + ".0.0"
  elsif (bits >= 17) && (bits <= 24)
    maskIp = "255.255." + (256 - (2 ** (24 - bits))).to_s + ".0"
  else
    maskIp = "255.255.255." + (256 - (2 ** (32 - bits))).to_s.to_s
  end
  return maskIp
end

#About space given by ISP
print "What is the network space given by your ISP? (e.g. 192.168.1.0/24): "
ispNetworkSpace = gets.chomp
ispMaskBits = Integer(ispNetworkSpace.split("/")[1])
ispMaskIp = getMaskIp(ispMaskBits)
ispQHost = 2 ** (32 - ispMaskBits)

#check whether IP given is a network address
ispNetwork = ""
for i in 0..3
  ispNetwork += (Integer(ispNetworkSpace.split("/")[0].split(".")[i]) & Integer(ispMaskIp.split(".")[i])).to_s
  if i < 3
    ispNetwork += "."
  end
end
puts "ISP network: " + ispNetwork
puts "ISP mask bits: /" + ispMaskBits.to_s
puts "ISP mask IP: " + ispMaskIp
puts "ISP number of hosts: " + ispQHost.to_s


#Number of host required in each subnet
puts
subnetQHost = 0
while subnetQHost < 2
  print "How many available hosts do you want in each subnet? "
  subnetQHost = Integer(gets)
  if subnetQHost < 2
    puts "At least there can only be 2 available hosts by subnet."
  end
end
subnetQHost += 2


#Calculate new network and mask addresses
subnetHostBits = 0
while (2 ** subnetHostBits) < subnetQHost
  subnetHostBits += 1
end

#info about hosts
puts subnetHostBits.to_s + " bits used by hosts"
subnetQHost = 2 ** subnetHostBits
puts subnetQHost.to_s + " hosts per subnet"

#info about subnets
subnetNetBits = 32 - ispMaskBits - subnetHostBits
puts subnetNetBits.to_s + " bits used by subnets"
subnetQNet = 2 ** subnetNetBits
puts subnetQNet.to_s + " subnets"
subnetMaskBit = 32 - subnetHostBits
puts "Subnet Mask Bit: /" + subnetMaskBit.to_s
subnetMaskIp = getMaskIp(subnetMaskBit)
puts "Subnet Mask IP: " + subnetMaskIp
