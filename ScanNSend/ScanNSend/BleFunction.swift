//
//  BleFunction.swift
//  ScanNSend
//
//  Created by Lightwave Technology on 2020-12-09.
//

import Foundation
import CoreBluetooth

var blePeripheral1: CBPeripheral!
var inputCommand: String!
let bleReadServiceNameCBUUID = CBUUID(string: "0xFFE0")
class BleFunction: NSObject {

    static let bleObj = BleFunction()
    var centralManager: CBCentralManager!

    override private init() {
        super.init()
        //centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startBLEFunction(inputString: String) {
        inputCommand = inputString
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

extension BleFunction: CBCentralManagerDelegate
{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {

        case .unknown:
            print("central.state is unknown")
        case .resetting:
            print("central.state is resetting")
        case .unsupported:
            print("central.state is unsupported")
        case .unauthorized:
            print("central.state is unauthorized")
        case .poweredOff:
            print("central.state is poweredOff")
        case .poweredOn:
            print("central.state is poweredOn")
            centralManager.scanForPeripherals(withServices: [bleReadServiceNameCBUUID])
        @unknown default:
            print("central.state is default")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //print("Inside central manager discovery function")
        print(peripheral)
        blePeripheral1 = peripheral
        blePeripheral1.delegate = self
        centralManager.stopScan()
        centralManager.connect(blePeripheral1)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Peripheral Connected!!")
        blePeripheral1.discoverServices([bleReadServiceNameCBUUID])

    }

}

extension BleFunction: CBPeripheralDelegate
{
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        for s in services {
            print(s)
            peripheral.discoverCharacteristics(nil, for: s)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        print(inputCommand!)
        for c in characteristics {
            print(c)
            let d1 = [UInt8] (inputCommand.utf8)
            print(d1)
            let d2 = NSData(bytes: d1, length: d1.count)
            print("\(d2)")
            peripheral.writeValue(d2 as Data, for: c, type: CBCharacteristicWriteType.withoutResponse)
            peripheral.setNotifyValue(true, for: c)

        }
    }
}

