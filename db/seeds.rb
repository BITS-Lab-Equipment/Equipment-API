MaintenanceRecord.delete_all
Equipment.delete_all
Category.delete_all

computing    = Category.create!(name: "Computing")
optics       = Category.create!(name: "Optics")
networking   = Category.create!(name: "Networking")
electronics  = Category.create!(name: "Electronics")

laptop1 = Equipment.create!(
  name: "Dell Latitude 5540",
  serial_number: "LAP-001",
  status: "available",
  category: computing
)

laptop2 = Equipment.create!(
  name: "MacBook Pro 14",
  serial_number: "LAP-002",
  status: "in_use",
  category: computing
)

microscope1 = Equipment.create!(
  name: "Olympus CX23 Microscope",
  serial_number: "MIC-001",
  status: "available",
  category: optics
)

microscope2 = Equipment.create!(
  name: "Zeiss Axiolab Microscope",
  serial_number: "MIC-002",
  status: "maintenance",
  category: optics
)

router1 = Equipment.create!(
  name: "Cisco Catalyst 2960",
  serial_number: "NET-001",
  status: "available",
  category: networking
)

router2 = Equipment.create!(
  name: "Ubiquiti EdgeRouter",
  serial_number: "NET-002",
  status: "in_use",
  category: networking
)

arduino1 = Equipment.create!(
  name: "Arduino Mega Kit",
  serial_number: "ARD-001",
  status: "available",
  category: electronics
)

oscilloscope = Equipment.create!(
  name: "Rigol DS1054Z Oscilloscope",
  serial_number: "OSC-001",
  status: "maintenance",
  category: electronics
)

MaintenanceRecord.create!(
  description: "Replaced cracked objective lens on Olympus unit.",
  performed_at: 10.days.ago,
  equipment: microscope1
)

MaintenanceRecord.create!(
  description: "Full service: cleaned optics, recalibrated stage.",
  performed_at: 3.days.ago,
  equipment: microscope2
)

MaintenanceRecord.create!(
  description: "Firmware update to IOS 15.2(7). Rebooted cleanly.",
  performed_at: 7.days.ago,
  equipment: router1
)

MaintenanceRecord.create!(
  description: "Replaced faulty power supply unit.",
  performed_at: 14.days.ago,
  equipment: oscilloscope
)

MaintenanceRecord.create!(
  description: "Capacitor bank replaced. Passed burn-in test.",
  performed_at: 2.days.ago,
  equipment: oscilloscope
)

puts "Seeded:"
puts "  #{Category.count} categories"
puts "  #{Equipment.count} equipment items"
puts "  #{MaintenanceRecord.count} maintenance records"